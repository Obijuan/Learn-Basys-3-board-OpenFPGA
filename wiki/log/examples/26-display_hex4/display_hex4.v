`default_nettype none   



//-- Mostrar un numero hexadecimal de 4 digitos
//-- en los 4 displays de menor peso
//-- El numero se obtiene de los switches
module display_hex4 (
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

//----------------------------
//-- PRESCALER
//----------------------------

prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);

//-- Generador de señal cuadrada
wire [1:0] gen;

//-------------------------
//--       MAIN
//-------------------------

//-- Seleccionar display
assign disp_sel = gen;

//---------------------------
//-- CONVERSORES BCD-7SEG
//---------------------------
wire [7:0] seg0;
bcd_to_7seg u_conv0_bcd2seg (
    .bcd_in(switches[3:0]),
    .disp_out(seg0)
);

wire [7:0] seg1;
bcd_to_7seg u_conv1_bcd2seg (
    .bcd_in(switches[7:4]),
    .disp_out(seg1)
);

wire [7:0] seg2;
bcd_to_7seg u_conv2_bcd2seg (
    .bcd_in(switches[11:8]),
    .disp_out(seg2)
);

wire [7:0] seg3;
bcd_to_7seg u_conv3_bcd2seg (
    .bcd_in(switches[15:12]),
    .disp_out(seg3)
);

//-- Mostrar los digitos en el display
assign seg = gen==2'b00 ? seg0 : 
             gen==2'b01 ? seg1 : 
             gen==2'b10 ? seg2 :
             gen==2'b11 ? seg3 : 
             8'h0;

endmodule

