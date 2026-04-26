`default_nettype none   



//-- Mostrar un numero hexadecimal de 2 digitos
//-- en los 2 displays de menor peso
module display_hex2 (
    input wire clk, 
    input wire [4:0] buttons,
    input wire [15:0] switches, 
    output wire [15:0] leds,
    output wire [7:0] segments,
    output wire [3:0] display_sel
);

//------ DISPLAY DE 7 SEGMENTOS
//-- Señales para el usuario, con logica positiva
wire [1:0] disp_sel; //-- Seleccion del display (0-3)
wire [7:0] seg;      //-- Segmentos a encender

//-- Mapear las señales del usuario a las reales
//-- Conexion con el display
assign segments = ~seg;

//-- Decodificador de 2 a 4, negado
assign display_sel = ~(1 << disp_sel);

//------ PULSADORES
//-- Constantes para pulsadores
localparam CENTER = 0;
localparam UP = 1;
localparam DOWN = 4;
localparam LEFT = 2;
localparam RIGHT = 3;

wire butt_right;
wire butt_right_press;
button_input u_btn0 (
    .clk(clk),
    .button_pin_in(buttons[RIGHT]), 
    .button_state_out(butt_right),
    .press_out(butt_right_press),
    .release_out()  //-- Sin conectar
);

wire butt_left;
wire butt_left_press;
button_input u_btn1 (
    .clk(clk),
    .button_pin_in(buttons[LEFT]), 
    .button_state_out(butt_left),
    .press_out(butt_left_press),
    .release_out()  //-- Sin conectar
);

//----------------------------
//-- PRESCALER
//----------------------------

prescaler #(.N(20)
) u_press0 (
    .clk(clk),

    .signal(gen),  
    .done()  //-- No usado
);

//-- Generador de señal cuadrada
wire gen;

//-------------------------
//--       MAIN
//-------------------------
//-- Contador BCD0
reg [3:0] num0 = 0;
always @(posedge clk) begin
    if (butt_right_press)
        num0 <= num0 + 1; 
end

//-- Contador BCD1
reg [3:0] num1 = 0;
always @(posedge clk) begin
    if (butt_left_press)
        num1 <= num1 + 1; 
end

//-- Seleccionar display
assign disp_sel = gen;

//---------------------------
//-- CONVERSOR BCD-7SEG
//---------------------------
wire [7:0] seg0;
bcd_to_7seg u_conv0_bcd2seg (
    .bcd_in(num0),
    .disp_out(seg0)
);

wire [7:0] seg1;
bcd_to_7seg u_conv1_bcd2seg (
    .bcd_in(num1),
    .disp_out(seg1)
);

//-- Mostrar el digito en el display, multiplexado
assign seg = gen ? seg1 : seg0;


endmodule

