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

