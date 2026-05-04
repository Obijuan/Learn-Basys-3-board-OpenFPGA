module mcu #(
    parameter real CLK_FREQUENCY_MHZ,
    parameter int  UART_BAUD_RATE,
    parameter int DEBOUNCER_SIZE
) (
    //-- Main system clk
    input logic clk,

    //-- Memory clock
    input logic clk_mem,

    //-- LEDs
    output logic [15:0] leds,

    //-- Buttons 0:center, 1: up, 2:left, 3:right, 4: down
    input  logic [4:0] buttons_async,

    //-- Switches
    input logic [15:0] switches_async
);

//-----------------------------------------------------------------------
//-- RESET: El reset se realiza tras 32 ciclos
//-- En las FPGAs ICE40 la memoria tarda 32 ciclos en inicializarse tras
//-- la carga del bitstream
//-----------------------------------------------------------------------
logic rst;
logic [6:0] rst_cnt = 7'b0;

assign rst = ~rst_cnt[5];

always_ff @( posedge(clk) ) begin
    if (rst_cnt[5]==0)
        rst_cnt <= rst_cnt + 1;
end

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE PULSADORES 
//───────────────────────────────────────────────────────────
localparam BOTONES = 5;
logic [4:0] buttons_sync;
for (genvar btn_i = 0; btn_i < BOTONES; btn_i++) begin : gen_0

    //-- Instanciar sincronizador para el boton i
    synchronizer u_btn_sync (
        .clk(clk),
        .async_in(buttons_async[btn_i]),
        .sync_out(buttons_sync[btn_i])
    );
end

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE SWITCHES 
//───────────────────────────────────────────────────────────
localparam SWITCHES = 16;
logic [15:0] switches_sync;
for (genvar sw_i = 0; sw_i < SWITCHES; sw_i++) begin : gen_1

    //-- Instanciar sincronizador para el boton i
    synchronizer u_btn_sync (
        .clk(clk),
        .async_in(switches_async[sw_i]),
        .sync_out(switches_sync[sw_i])
    );
end

//--------------------------------------------------
//-- ANTIRREBOTES
//--------------------------------------------------

//-- Antirrebotes para sw1
logic [4:0] buttons_rdy;
debounce #(
    .SIZE(DEBOUNCER_SIZE)
) u_debouncer1 (
    .clk(clk),

    .value_in(buttons_sync[0]),
    .value_out(buttons_rdy[0])
);


//------------------------------------------
//-- PERIFERICOS
//------------------------------------------
import constants::MEMORY_START;
import constants::MEMORY_SIZE;

//-- Acceso a la memoria
wishbone_interface fetch_bus();
wishbone_interface mem_bus();

wishbone_interface mem_bus_slaves[1]();
wishbone_interconnect #(
    .NUM_SLAVES(1),
    .SLAVE_ADDRESS({
        MEMORY_START
    }),
    .SLAVE_SIZE({
        MEMORY_SIZE
    })
) peripheral_bus_interconnect (
    .clk(clk),
    .rst(rst),
    .master(mem_bus),
    .slaves(mem_bus_slaves)
);

//-- MEMORIA RAM
wishbone_ram #(
    .ADDRESS(MEMORY_START),
    .SIZE(MEMORY_SIZE)
) ram (
    .clk(clk_mem),
    .rst(rst),
    .port_a(fetch_bus.slave),
    .port_b(mem_bus_slaves[0])
);


//------------------------------------
//-- FETCH STAGE
//------------------------------------

//-- Output signals
logic [31:0] fetch_instruction_reg;
logic [31:0] fetch_program_counter_reg;

//-- Pipeline control signal
pipeline_status::forwards_t fetch_status_forwards;
pipeline_status::backwards_t decode_status_backwards;
logic [31:0] decode_jump_address_backwards;

fetch_stage u_fetch (
    .clk(clk), 
    .rst(rst),

    //-- Memory interface
    .wb(fetch_bus),

    //-- Output data
    .instruction_reg_out(fetch_instruction_reg),
    .program_counter_reg_out(fetch_program_counter_reg),

    //-- Pipeline control
    .status_forwards_out(fetch_status_forwards),
    .status_backwards_in(decode_status_backwards),
    .jump_address_backwards_in(decode_jump_address_backwards)
);

//---------------------------------------
//-- Conexiones para eliminar warnings
//---------------------------------------
assign mem_bus.cyc = 0;
assign mem_bus.stb = 0;
assign mem_bus.sel = 4'b1111;
assign mem_bus.we = 0;
assign mem_bus.adr = 32'h0;

//----------------------------
//-- TEST
//-----------------------------

//-- No hay salto en las etapas posteriores
assign decode_jump_address_backwards = 32'h0;

//-- Señal de comienzo
logic start;
assign start = rst_cnt[5];


//-- Mostrar informacion en los LEDs según el estado
//-- de los switches
logic [15:0] data_lower;
logic [15:0] data_upper;

//-- El switch 15 selecciona si queremos ver el contador
//-- de programa (1) o la instruccion (0)
assign data_lower = (switches_sync[15])? 
           fetch_program_counter_reg[15:0] :
           fetch_instruction_reg[15:0];

assign data_upper = (switches_sync[15])? 
           fetch_program_counter_reg[31:16] :
           fetch_instruction_reg[31:16];

//-- El switch 0 seleccion si vemos los 16-bits menores (0) o los mayores (1)
assign leds = (switches_sync[0])? data_upper : data_lower; 

//---------------------------
//-- Pruebas de pulsadores
//---------------------------

//-- Detector de flanco de subida en sw1
logic sw1_click;
posedge_detector u_sw1_click (
    .clk(clk),
    .value(buttons_rdy[0]),
    .pos_edge(sw1_click)
);


//---------------------------------------
//-- AUTOMATA DE PRUEBA para Fetch
//---------------------------------------
logic INIT = 1; //-- INIT: esperar señal start para arrancar
logic E0 = 0;  //-- E0: STALL
logic E1 = 0;  //-- E1: READY

//-- Estado
logic next;
always_ff @( posedge clk ) begin
    if (rst) begin
        INIT <= 1;
        E0 <= 0;
        E1 <= 0;
    end
    else if (next) begin
        INIT <= 0;
        E0 <= E1 || INIT;
        E1 <= E0;
    end
end

//-- Transiciones
logic T_INIT;
assign T_INIT = INIT && start;

logic T01;
assign T01 = E0 && sw1_click;

logic T10;
assign T10 = E1;

assign next = T_INIT || T01 || T10;

//-- Salidas del automata
always_comb begin

    //-- Salidas por defecto
    decode_status_backwards = pipeline_status::READY;

    if (INIT) begin
        decode_status_backwards = pipeline_status::READY;
    end
    else if (E0) begin
        decode_status_backwards = pipeline_status::STALL;
    end
    else if (E1) begin
        decode_status_backwards = pipeline_status::READY;
    end
end

endmodule
