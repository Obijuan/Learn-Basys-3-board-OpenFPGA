`default_nettype none   

//-- Mosrar el mensaje "HOLA" en los displays

module display_letters (
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

//──────────────────────
//──  PRESCALER 
//──────────────────────
wire [1:0] gen;

prescaler2 #(.N(20)
) u_press0 (
    .clk(clk),
    .signal(gen),  
);


//-- Funcion para obtener el codigo de cada
//-- letra, a partir de su codigo ASCII
function [7:0] letra (
    input [7:0] car
);

    letra = car-65;
endfunction

//─────────────────────────
//──       MAIN
//─────────────────────────
//-- Seleccionar display
assign disp_sel = gen;

//-- Mostrar las letras en el display
assign seg = letter;

//-- Letras a sacar en el display
assign code = gen==2'b11 ? letra("H") :
              gen==2'b10 ? letra("O") :
              gen==2'b01 ? letra("L") :
              gen==2'b00 ? letra("A") :
              8'h0;

//-- Generador de letras
wire [7:0] letter;
wire [4:0] code;
disp_letter u_disp_letter0 (
    .code_in(code),
    .letter_out(letter)
);

endmodule

