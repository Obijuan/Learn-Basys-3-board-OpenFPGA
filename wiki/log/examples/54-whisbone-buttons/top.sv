module top(
    input logic clk,

    //-- BOTONES
    input wire [4:0] buttons,

    //-- LEDs
    output logic [15:0] leds
);

//-- Conexion a los leds
logic [15:0] led_o;

//-- Mostrar en los LEDs
assign leds = led_o;

//-- Botones sincronizados
logic [4:0] buttons_sync;

//-- Pulsador de reset
logic rst;
assign rst = 0;

//----------- Conexion de perifericos a traves del wishbone

//-- Bus de acceso a perifericos
wishbone_interface mem_bus();

//------------- PERIFERICOS

//-- Dos puertos
wishbone_interface mem_bus_slaves[2]();

//-- Puerto de LEDs
localparam bit [31:0] LEDS_START = 32'h0008_0000;
localparam bit [31:0] LEDS_SIZE  = 32'h0000_0001;

//-- Puerto de pulsadores
localparam bit [31:0] BUTTONS_START = 32'h0008_1000;
localparam bit [31:0] BUTTONS_SIZE = 32'h0000_0001;

//───────────────────────────────────────────────────────────
//──              BUS WISHBONE 
//───────────────────────────────────────────────────────────
wishbone_interconnect #(
        .NUM_SLAVES(2),
        .SLAVE_ADDRESS({
            LEDS_START,
            BUTTONS_START
        }),
        .SLAVE_SIZE({
            LEDS_SIZE,
            BUTTONS_SIZE
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

//───────────────────────────────────────────────────────────
//──         SINCRONIZACION DE PULSADORES 
//───────────────────────────────────────────────────────────

//-- TODO: convertirlo en generico
synchronizer u_sync0 (
    .clk(clk),
    .async_in(buttons[0]),
    .sync_out(buttons_sync[0])
);

synchronizer u_sync1 (
    .clk(clk),
    .async_in(buttons[1]),
    .sync_out(buttons_sync[1])
);

synchronizer u_sync2 (
    .clk(clk),
    .async_in(buttons[2]),
    .sync_out(buttons_sync[2])
);

synchronizer u_sync3 (
    .clk(clk),
    .async_in(buttons[3]),
    .sync_out(buttons_sync[3])
);

synchronizer u_sync4 (
    .clk(clk),
    .async_in(buttons[4]),
    .sync_out(buttons_sync[4])
);


//───────────────────────────────────────────────────────────
//──         AUTOMATA 
//───────────────────────────────────────────────────────────
//──  Leer pulsadores y mostrar su valor en los LEDs

//── ESTADOS
logic E0 = 1;  //-- Estado inicial: Lectura botones
logic E1 = 0;  //-- Escritura en LEDs

//── TRANSICIONES
logic T01;
assign T01 = E0 && mem_bus.ack;

logic T12;
assign T12 = E1 && mem_bus.ack;

//── Logica para pasar al siguiente estado
logic next;
assign next = T01 || T12;


//── Registro intermedio con el valor de los botones
logic [4:0] btn_reg;
logic capture;
always_ff @( posedge clk ) begin 
    if (T01)
        btn_reg <= mem_bus.dat_miso[4:0];
end

//── BIESTABLES DE ESTADO
always_ff @( posedge clk ) begin 
    if (next) begin
        E0 <= E1;
        E1 <= E0;
    end
end


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
        mem_bus.sel = 4'b0001;
        mem_bus.stb = 1;
        mem_bus.adr = BUTTONS_START;
        mem_bus.we = 0;
        //-- Se leen en la transicion en el 
        //-- registro btn_reg
    end

    //-- Escritura en LEDs
    else if (E1) begin
        mem_bus.cyc = 1;
        mem_bus.sel = 4'b0011;
        mem_bus.stb = 1;
        mem_bus.adr = LEDS_START;
        mem_bus.we = 1;
        mem_bus.dat_mosi = {16'b0, btn_reg, 11'b0};
    end
end

endmodule

