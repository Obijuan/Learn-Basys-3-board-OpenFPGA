`default_nettype none   



//-- Mostrar un digito BCD en el display 7 segmentos
//-- Con el botón de UP se incrementa el numero que se muestra
//-- en el display 0
module disp0_bcd (
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

wire butt_up;
wire butt_up_press;
button_input u_btn_izq (
    .clk(clk),
    .button_pin_in(buttons[UP]), 
    .button_state_out(butt_up),
    .press_out(butt_up_press),
    .release_out()  //-- Sin conectar
);


//-------------------------
//--       MAIN
//-------------------------
//-- Contador BCD
reg [3:0] num = 0;
always @(posedge clk) begin
    if (butt_up_press)
        num <= num + 1; 
end

//-- Seleccionar display
assign disp_sel = 0;

//---------------------------
//-- CONVERSOR BCD-7SEG
//---------------------------
bcd_to_7seg u_conv_bcd2seg (
    .bcd_in(num),
    .disp_out(seg)
);


endmodule

