module top(
    input logic clk,

    //-- LEDs
    output logic [15:0] leds,

    //-- BOTONES
    input logic [4:0] buttons,

    //-- Switches
    input  logic [15:0] switches,
    
    //-- SERIAL PORT
    input  logic uart_rx_async,
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
logic [15:0] leds_o;

//-- Botones sincronizados
logic [4:0] buttons_sync;

//-- Switches sincronizados
logic [15:0] switches_sync;

//-- Cable de recepcion serie
logic rx_serial_in;

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
    .leds(leds_o),
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
//──         SINCRONIZACION DE RX
//───────────────────────────────────────────────────────────
synchronizer u_rx_sync (
    .clk(clk),
    .async_in(uart_rx_async),
    .sync_out(rx_serial_in)
);

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


//-- Registros intermedio con el valor de los botones
logic [4:0] btn_reg;
logic [4:0] btn_reg_old;
always_ff @( posedge clk ) begin 
    if (T01) begin
        //-- Estado actual del pulsador
        btn_reg <= mem_bus.dat_miso[4:0];

        //-- Estado anterior pulsador
        btn_reg_old <= btn_reg;

    end
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
        data_out = (switches_reg[15]) ? {switches_reg[15:13], btn_reg[4:0], 8'h0} :
                                        {switches_reg[15:8], 8'h0};
        mem_bus.dat_mosi = {16'h0, data_out};
    end
end

//-------- Detectar cambios en el estado de los botones
//-- Pulsador central apretado
logic btn_press;
assign btn_press = btn_reg[0] & !btn_reg_old[0]; 


//───────────────────────────────────────────────────────────
//──      UART: TRANSMISOR 
//───────────────────────────────────────────────────────────
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

//---- Pruebas de transmisión
//-- Envio de un caracter al apretar el pulsador central
assign tx_byte = "A";
assign tx_start = btn_press;

//---- Conectar el pin TX
assign uart_tx = tx_serial_out;


//───────────────────────────────────────────────────────────
//──      UART: RECEPTOR
//───────────────────────────────────────────────────────────
logic [7:0] rx_byte;
logic rx_done;
logic rx_error;

uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
) u_rx (
    .clk(clk),
    .rst(rst),

    // Serial input
    .rx_serial_in(rx_serial_in),

    // Output signals
    .rx_byte_out(rx_byte),
    .rx_done_out(rx_done),
    .rx_error_out(rx_error)
);

//-- Capturar el dato recibido
logic [7:0] rx_byte_r;
always_ff @( posedge(clk) ) begin
    if (rx_done) begin
        rx_byte_r <= rx_byte;
    end
end

//-- Sacar información por los LEDs
always_ff @(posedge(clk)) begin
    leds <= {leds_o[15:8], rx_byte_r};
end

endmodule

