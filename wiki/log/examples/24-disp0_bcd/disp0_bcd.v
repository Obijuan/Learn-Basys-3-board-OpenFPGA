`default_nettype none   



//-- Mostrar un digito BCD en el display 7 segmentos
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

//----- Conversion de BCD a 7SEGMENTOS
reg [7:0] d7seg;
wire [3:0] bcd;
always @* begin
    case (bcd)
        4'h0: d7seg <= 8'h3F;
        4'h1: d7seg <= 8'h06;
        4'h2: d7seg <= 8'h5B;
        4'h3: d7seg <= 8'h4F;
        4'h4: d7seg <= 8'h66;
        4'h5: d7seg <= 8'h6D;
        4'h6: d7seg <= 8'h7D;
        4'h7: d7seg <= 8'h07;
        4'h8: d7seg <= 8'h7F; 
        4'h9: d7seg <= 8'h6F;
        4'hA: d7seg <= 8'h77;
        4'hB: d7seg <= 8'h7C;
        4'hC: d7seg <= 8'h39;
        4'hD: d7seg <= 8'h5E;
        4'hE: d7seg <= 8'h79;
        4'hF: d7seg <= 8'h71; 
        default: d7seg <= 8'h00; 
    endcase
end

reg [3:0] num = 0;
always @(posedge clk) begin
    if (butt_up_press)
        num <= num + 1; 
end

//-- Digito bcd a mostrar
assign bcd = num;

//-- Seleccionar display
assign disp_sel = 0;

//-- Mostrar resultado en el display
assign seg = d7seg;

//-- Llevar los 8 switches de menor peso a sus
//-- correspondientes leds
assign leds[7:0] = switches[7:0];

endmodule

