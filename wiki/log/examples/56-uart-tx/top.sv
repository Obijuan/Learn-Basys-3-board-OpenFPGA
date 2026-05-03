module top(
    input logic clk,

    //-- LEDs
    output logic [15:0] leds,

    //-- BOTONES
    input logic [4:0] buttons,

    //-- Switches
    input  logic [15:0] switches,
    
    //-- SERIAL PORT
    output logic uart_tx
);


//-- Parametros del reloj
localparam real SYS_CLK_FREQ_MHZ = 100;
localparam real SYS_CLK_PERIOD_PS = (1 / SYS_CLK_FREQ_MHZ)*1000*1000;
localparam int  SIM_CLK_PERIOD = int'(SYS_CLK_PERIOD_PS);
localparam real CLK_FREQUENCY_MHZ = SYS_CLK_FREQ_MHZ;

//-- Parametros para la UART
localparam int BAUD_RATE = 115200;
localparam int CLKS_PER_BIT =int'(CLK_FREQUENCY_MHZ*1_000_000.0/BAUD_RATE);

//-- Conexion a los leds
logic [15:0] led_o;

//-- Mostrar en los LEDs
assign leds = led_o;

//-- Botones sincronizados
logic [4:0] buttons_sync;

//-- Switches sincronizados
logic [15:0] switches_sync;

//-- Pulsador de reset
logic rst;
assign rst = 0;


//----------- Conexion de perifericos a traves del wishbone

//-- Bus de acceso a perifericos
wishbone_interface mem_bus();

//------------- PERIFERICOS

//-- Buses para los esclavos
wishbone_interface mem_bus_slaves[3]();

//-- Puerto de LEDs
localparam bit [31:0] LEDS_START = 32'h0008_0000;
localparam bit [31:0] LEDS_SIZE  = 32'h0000_0001;

//-- Puerto de pulsadores
localparam bit [31:0] BUTTONS_START = 32'h0008_1000;
localparam bit [31:0] BUTTONS_SIZE = 32'h0000_0001;

//-- Puerto de switches
localparam bit [31:0] SWITCHES_START = 32'h0008_2000;
localparam bit [31:0] SWITCHES_SIZE = 32'h0000_0001;

//───────────────────────────────────────────────────────────
//──              BUS WISHBONE 
//───────────────────────────────────────────────────────────
wishbone_interconnect #(
        .NUM_SLAVES(3),
        .SLAVE_ADDRESS({
            LEDS_START,
            BUTTONS_START,
            SWITCHES_START
        }),
        .SLAVE_SIZE({
            LEDS_SIZE,
            BUTTONS_SIZE,
            SWITCHES_SIZE
        })
    ) peripheral_bus_interconnect (
        .clk(clk),
        .rst(rst),
        .master(mem_bus),
        .slaves(mem_bus_slaves)
);


//──────────────────────────────────────
//──   PERIFERICO WISHBONE: LEDS 
//──────────────────────────────────────
wishbone_leds #(
    .ADDRESS(LEDS_START),
    .SIZE(LEDS_SIZE)
) u_wishbone_leds (
    .clk(clk),
    .rst(rst),
    .leds(leds),
    .wishbone(mem_bus_slaves[0])
);

//──────────────────────────────────────
//──   PERIFERICO WISHBONE: BOTONES
//──────────────────────────────────────
wishbone_buttons #(
    .ADDRESS(BUTTONS_START),
    .SIZE(BUTTONS_SIZE)
) u_wishbone_buttons (
    .clk(clk),
    .rst(rst),
    .buttons(buttons),
    .wishbone(mem_bus_slaves[1])
);

//──────────────────────────────────────
//──   PERIFERICO WISHBONE: SWITCHES
//──────────────────────────────────────
wishbone_switches #(
    .ADDRESS(SWITCHES_START),
    .SIZE(SWITCHES_SIZE)
) u_wishbone_switches (
    .clk(clk),
    .rst(rst),
    .switches(switches),
    .wishbone(mem_bus_slaves[2])
);

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE PULSADORES 
//───────────────────────────────────────────────────────────
localparam BOTONES = 5;
for (genvar btn_i = 0; btn_i < BOTONES; btn_i++) begin : gen_0

    //-- Instanciar sincronizador para el boton i
    synchronizer u_btn_sync (
        .clk(clk),
        .async_in(buttons[btn_i]),
        .sync_out(buttons_sync[btn_i])
    );
end


//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE SWITCHES 
//───────────────────────────────────────────────────────────
localparam SWITCHES = 16;
for (genvar sw_i = 0; sw_i < SWITCHES; sw_i++) begin : gen_1

    //-- Instanciar sincronizador para el boton i
    synchronizer u_btn_sync (
        .clk(clk),
        .async_in(switches[sw_i]),
        .sync_out(switches_sync[sw_i])
    );
end



//───────────────────────────────────────────────────────────
//──         AUTOMATA 
//───────────────────────────────────────────────────────────
//──  Leer switches y pulsadores y mostrar su valor en los leds

//── ESTADOS
logic E0 = 1;  //-- Estado inicial: Lectura botones
logic E1 = 0;  //-- Lectura de switches
logic E2 = 0;  //-- Escritura en LEDs

//── TRANSICIONES
logic T01;
assign T01 = E0 && mem_bus.ack;

logic T12;
assign T12 = E1 && mem_bus.ack;

logic T20;
assign T20 = E2 && mem_bus.ack;

//── Logica para pasar al siguiente estado
logic next;
assign next = T01 || T12 || T20;


//-- Registro intermedio con el valor de los botones
logic [4:0] btn_reg;
always_ff @( posedge clk ) begin 
    if (T01)
        btn_reg <= mem_bus.dat_miso[4:0];
end

//-- Registro intermedio con el valor de los switches
logic [15:0] switches_reg;
always_ff @( posedge clk ) begin
    if (T12)
        switches_reg <= mem_bus.dat_miso[15:0];
end

//── BIESTABLES DE ESTADO
always_ff @( posedge clk ) begin 
    if (next) begin
        E0 <= E2;
        E1 <= E0;
        E2 <= E1;
    end
end

logic [15:0] data_out;

//── SALIDAS: Valor de las señales en cada estado
always_comb begin

    //-- Valor por defecto de las señales
    mem_bus.cyc = 0;
    mem_bus.sel = 4'b0;
    mem_bus.stb = 0;
    mem_bus.adr = 32'h0;
    mem_bus.dat_mosi = 32'h0;
    mem_bus.we = 0;

    //-- Lectura de botones
    if (E0) begin
        mem_bus.cyc = 1;
        mem_bus.sel = 4'b0011;
        mem_bus.stb = 1;
        mem_bus.adr = BUTTONS_START;
        mem_bus.we = 0;
        //-- Se leen en la transicion en el 
        //-- registro btn_reg
    end

    //-- Lectura de switches
    else if (E1) begin
        mem_bus.cyc = 1;
        mem_bus.sel = 4'b0011;
        mem_bus.stb = 1;
        mem_bus.adr = SWITCHES_START;
        mem_bus.we = 0;
        //-- Se leen en la transicion en el 
        //-- registro switches_reg
    end

    //-- Escritura en LEDs
    else if (E2) begin
        mem_bus.cyc = 1;
        mem_bus.sel = 4'b0011;
        mem_bus.stb = 1;
        mem_bus.adr = LEDS_START;
        mem_bus.we = 1;

        //-- Si switch 15 está activo, se muestra en los LEDs
        //-- los pulsadores
        data_out = (switches_reg[15]) ? {switches_reg[15:5], btn_reg[4:0]} :
                                        {switches};
        mem_bus.dat_mosi = data_out;
    end
end

//------------ Instanciar el transmisor de la UART
logic tx_start;
logic [7:0] tx_byte;
logic tx_serial_out;
logic tx_done;
logic tx_active;

uart_tx_module #(
   .CLKS_PER_BIT(CLKS_PER_BIT)
) u_tx (
    .clk(clk),
    .rst(rst),

    // Input signals
    .tx_start_in(tx_start),
    .tx_byte_in(tx_byte),

    // Output signals
    .tx_serial_out(tx_serial_out),
    .tx_done_out(tx_done),
    .tx_active_out(tx_active)
);


//-- Pruebas de transmisión
assign tx_byte = "A";
assign tx_start = btn_reg[0];

//-- Drive the serial tx pin
assign uart_tx = tx_serial_out;


endmodule

