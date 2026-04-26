`default_nettype none   


//-- Encender los segmentos del display actual con los switches
//-- Con el botón izquierdo se selecciona el siguiente display
module display_switches (
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

wire butt_izq;
wire butt_izq_press;
button_input u_btn_izq (
    .clk(clk),
    .button_pin_in(buttons[LEFT]), 
    .button_state_out(butt_izq),
    .press_out(butt_izq_press),
    .release_out()  //-- Sin conectar
);

//-------------------------
//--       MAIN
//-------------------------
//-- Llevar los 8 switches de menor peso a sus
//-- correspondientes leds
assign leds[7:0] = switches[7:0];

//-- Llevar los swithces a los segmentos
assign seg = switches[7:0];

//-- Contador para seleccionar el display actual
reg [1:0] ndisp = 0;
always @(posedge clk) begin
    if (butt_izq_press)
      ndisp <= ndisp + 1;
end

//-- Seleccionar display indicado por el contador
assign disp_sel = ndisp;

endmodule

