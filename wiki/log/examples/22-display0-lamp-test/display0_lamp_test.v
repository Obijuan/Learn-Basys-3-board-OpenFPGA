`default_nettype none   


module display0_lamp_test (
    input wire clk, 
    input wire [4:0] buttons,
    input wire [15:0] switches, 
    output wire [15:0] leds,
    output wire [7:0] segments,
    output wire [3:0] display_sel
);

//------ DISPLAY DE 7 SEGMENTOS
//-- Señales para el usuario, con logica positiva
wire [3:0] disp_sel; //-- Seleccion del display (0-3)
wire [7:0] seg;      //-- Segmentos a encender


assign display_sel = 4'b1110;
assign segments = 8'h00;

// //-- Conexion con el display
// assign segments = ~seg;

// //-- Decodificador 2 a 4. Negado
// assign display_sel = ~(1 << disp_sel);

// //--------- MAIN

// //-- Seleccionar display 0 (0, 1, 2 y 3)
// assign display_sel = 4'h0;

// //-- Encender todos los segmentos y el punto
// assign segments = 8'h01;

endmodule

