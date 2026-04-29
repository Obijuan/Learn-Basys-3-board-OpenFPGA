`default_nettype none   
`include "buttons.vh"   


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

//─────────────────────────────────
//──   DISPLAY DE 7 SEGMENTOS
//─────────────────────────────────
//-- Señales para el usuario, con logica positiva
wire [7:0] seg;      //-- Segmentos a encender
wire [1:0] disp_sel; //-- Seleccion del display (0-3)

display7seg u_disp7 (
    .seg_in(seg),
    .sel_in(disp_sel),

    //-- Conexion al display físico
    .segments_out(segments),
    .display_sel_out(display_sel)
);

//──────────────────────────────────
//── CONVERSORES BCD-7SEG
//──────────────────────────────────
wire [3:0] num;
bcd_to_7seg u_conv_bcd2seg0 (
    .bcd_in(num),
    .disp_out(seg)
);

//────────────────────────────────────────────
//── PULSADORES
//────────────────────────────────────────────
wire btn_right;
wire btn_right_press;

normal_button u_btn_right(
    .clk(clk),
    .btn_pin(buttons[BTN_RIGHT]),  
    .btn_state(btn_right),
    .tic_press(btn_right_press),
    .tic_release(), 
);

wire btn_left;
wire btn_left_press;
normal_button u_btn_left(
    .clk(clk),
    .btn_pin(buttons[BTN_LEFT]),  
    .btn_state(btn_left),
    .tic_press(btn_left_press),
    .tic_release(), 
);


//─────────────────────────────────────
//──  PRESCALER DE N BITS
//─────────────────────────────────────
//-- Generador de señal cuadrada
wire gen;
prescaler #(.N(20)
) u_press0 (
    .clk(clk),

    .signal(gen),  
    .done()
);

//─────────────────────────────────
//──   MAIN
//─────────────────────────────────

//-- Contador BCD0
reg [3:0] num0 = 0;
always @(posedge clk) begin
    if (btn_right_press)
        num0 <= num0 + 1; 
end

//-- Contador BCD1
reg [3:0] num1 = 0;
always @(posedge clk) begin
    if (btn_left_press)
        num1 <= num1 + 1; 
end

//-- Seleccionar display
//-- Alternar entre el display 1 y 0
assign disp_sel = {1'b0, gen};

//-- Multiplexar los digitos
assign num = gen ? num1 : num0;

endmodule

