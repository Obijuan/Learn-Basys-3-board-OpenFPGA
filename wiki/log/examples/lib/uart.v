//══════════════════════════════════════════════════════════
//─ MODULOS DE ACCESO A LA UART
//══════════════════════════════════════════════════════════

//──────────────────────────────
//──  TRANSMISOR SERIE
//──────────────────────────────
module uart_tx_module (
    input wire clk,
    input wire start_in,        //-- Comienzo de la transmision
    input wire [7:0] data_in,   //-- Data a transmitir

    output wire tx_pin_out,   //-- Pin de TX
    output wire busy_out,     //-- Está transmitiendo
    output wire done_out      //-- Transmisión terminada
);

//-- Tiempo de bit, en ciclos
//localparam CLK_FREQ_MHZ = 100
//localparam BAUD_RATE = 115200
//CLK_PER_BIT = CLK_FREQUENCY_MHZ*1_000_000.0/BAUD_RATE
localparam CLK_PER_BIT = 868; //-- 115200 Baudios

//──────────── Temporizador de transmisión de bits
//── Señal bit: Ha transcurrido el tiempo de un bit
//── Hay que enviar el siguiente
wire bit;
reg [9:0] count;
always @(posedge clk) begin
    if (bit)
        count = 10'h0;
    else
        count <= count + 1;
end

//-- Reiniciar contador cuando ha transcurrido
//-- el tiempo
assign bit = (count == CLK_PER_BIT) | Tstart;

//-- Bits de START y STOP
localparam START = 1'b0;
localparam STOP = 1'b1;

//-- Registro de transmisión
//-- Contiene bit de start, 8 bits de datos y uno de stop
reg [9:0] data_reg = 10'b1_1111_1111_1;
wire load_data;
always @(posedge clk) begin
    if (load_data)
        data_reg = {STOP, data_in, START};

    //-- Transmision del un bit
    else if (Tbit)
        data_reg = {1'b1, data_reg[9:1]};
end

//────────────────────────────────
//──    AUTOMATA
//────────────────────────────────
//-- Se usa una máquina de estados con codificacion 1-HOT

//--       transmit         bit        bit     bit        bit        bit
//--  E_IDLE ──────> E_START ─> E_BIT0 ──> ... ──> E_BIT7 ──> E_STOP ───> +
//--     ^                                                                |
//--     |                                                                |
//--     +-──────────────────────────────<────────────────────────────────+

//-- Estados
reg E_IDLE  = 1;  //-- Reposo. Esperando
reg E_START = 0;  //-- Envio del bit de start
reg E_BIT0  = 0;  //-- Envío bit0
reg E_BIT1  = 0;  //-- Envio bit1
reg E_BIT2  = 0;  //-- Envío bit2
reg E_BIT3  = 0;  //-- Envio bit3
reg E_BIT4  = 0;  //-- Envío bit4
reg E_BIT5  = 0;  //-- Envio bit5
reg E_BIT6  = 0;  //-- Envío bit6
reg E_BIT7  = 0;  //-- Envio bit7
reg E_STOP  = 0;  //-- Envío del bit de stop

//-- Cambio de estado
wire next;
always @(posedge clk) begin
    if (next) begin
        E_START <= E_IDLE;
        E_BIT0 <= E_START;
        E_BIT1 <= E_BIT0;
        E_BIT2 <= E_BIT1; 
        E_BIT3 <= E_BIT2;
        E_BIT4 <= E_BIT3;
        E_BIT5 <= E_BIT4;
        E_BIT6 <= E_BIT5;
        E_BIT7 <= E_BIT6;
        E_STOP <= E_BIT7;
        E_IDLE <= E_STOP;
    end 
end

//----- Transiciones
wire Tstart;  //-- E_IDLE --> E_START
assign Tstart = E_IDLE & start_in;

//-- En la transicion Tstart se carga el dato y se arranca el temporizador
assign load_data = Tstart;

//-- Transiciones de bit
wire Tbit;
assign Tbit = (E_START || E_BIT0 || E_BIT1 || E_BIT2 ||
               E_BIT3  || E_BIT4 || E_BIT5 || E_BIT6 ||
               E_BIT7  || E_STOP) & bit;

//-- Siguiente estado
assign next = Tstart || Tbit;

//-- Señal de done
assign done_out = E_STOP & bit;

//-- Señal de busy
assign busy_out = E_BIT0 || E_BIT1 || E_BIT2 || E_BIT3 || E_START ||
                  E_BIT4 || E_BIT5 || E_BIT6 || E_BIT7 || E_STOP;

//-- Conectar al pin de transmision
assign tx_pin_out = data_reg[0];

endmodule


//──────────────────────────────
//──  RECEPTOR SERIE
//──────────────────────────────
module uart_rx_module (
    input wire clk,
    input wire rx_pin_in,       //-- Pin RX
    output wire [7:0] data_out, //-- Caracter recibido
    output wire done_out,       //-- Tic de caracter recibido
);

//-- Tiempo de bit, en ciclos
localparam CLK_PER_BIT = 868; //-- 115200 Baudios
localparam CLK_PER_BIT_DIV2 = CLK_PER_BIT >> 1;

//-- Sincronizador
wire rx_sync;
synchronizer u_sync0 (
    .clk(clk),
    .async_in(rx_pin_in),  //-- Entrada asíncrona
    .sync_out(rx_sync)     //-- Salida sincronizada
);

//-- Detectar llegada caracter nuevo
//-- Sabes que llega un caracter nuevo cuando llega un flanco
//-- de bajada por rx. Esto activa la señal start!
wire start;
negedge_detector u_neg_edge0 (
    .clk(clk),
    .value(rx_sync),
    .tic(start)
);

//──────────── Temporizador de recepcion serie
reg [9:0] cnt;
wire bit;
always @(posedge clk) begin
    if (E_IDLE)
        cnt <= CLK_PER_BIT_DIV2;  //-- Valor inicial: medio periodo de bit
    else if (bit)
        cnt <= CLK_PER_BIT;  //-- Reiniciar. Siguiente bit
    else
        cnt <= cnt - 1;  //-- Un ciclo menos 
end

//-- La cuenta ha finalizado!
assign bit = (cnt == 10'h0);

//-- Bits de START y STOP
localparam START = 1'b0;
localparam STOP = 1'b1;

//-- Registro de recepcion
//-- Contiene bit de start, 8 bits de datos y uno de stop
reg [9:0] data_reg = 10'b0;
always @(posedge clk) begin
    //-- Leer el bit recibido
    if (bit)
        data_reg = {rx_sync, data_reg[9:1]};
end




//────────────────────────────────
//──    AUTOMATA
//────────────────────────────────
//-- Se usa una máquina de estados con codificacion 1-HOT

//--       transmit         bit        bit     bit        bit        bit
//--  E_IDLE ──────> E_START ─> E_BIT0 ──> ... ──> E_BIT7 ──> E_STOP ───> +
//--     ^                                                                |
//--     |                                                                |
//--     +-──────────────────────────────<────────────────────────────────+

//-- Estados
reg E_IDLE  = 1;  //-- Reposo. Esperando
reg E_START = 0;  //-- Recepcion bit de start
reg E_BIT0  = 0;  //-- Recepcion bit0
reg E_BIT1  = 0;  //-- Recepcion bit1
reg E_BIT2  = 0;  //-- Recepcion bit2
reg E_BIT3  = 0;  //-- Recepcion bit3
reg E_BIT4  = 0;  //-- Recepcion bit4
reg E_BIT5  = 0;  //-- Recepcion bit5
reg E_BIT6  = 0;  //-- Recepcion bit6
reg E_BIT7  = 0;  //-- Recepcion bit7
reg E_STOP  = 0;  //-- Recepcion del bit de stop


//-- Cambio de estado
wire next;
always @(posedge clk) begin
    if (next) begin
        E_START <= E_IDLE;
        E_BIT0 <= E_START;
        E_BIT1 <= E_BIT0;
        E_BIT2 <= E_BIT1; 
        E_BIT3 <= E_BIT2;
        E_BIT4 <= E_BIT3;
        E_BIT5 <= E_BIT4;
        E_BIT6 <= E_BIT5;
        E_BIT7 <= E_BIT6;
        E_STOP <= E_BIT7;
        E_IDLE <= E_STOP;
    end 
end

//----- Transiciones
wire Tstart;  //-- E_IDLE --> E_START
assign Tstart = E_IDLE & start;

//-- Transiciones de bit
wire Tbit;
assign Tbit = (E_START || E_BIT0 || E_BIT1 || E_BIT2 ||
               E_BIT3  || E_BIT4 || E_BIT5 || E_BIT6 ||
               E_BIT7  || E_STOP) & bit;

//-- Siguiente estado
assign next = Tstart || Tbit;

//-- Señal de done
assign done_out = E_STOP & bit;

//-- Datos recibidos
assign data_out = data_reg[8:1];


endmodule

