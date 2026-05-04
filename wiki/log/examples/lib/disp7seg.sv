//══════════════════════════════════════════════════════════
//─ Bibloteca para los DISPLAYS DE 7 SEGMENTOS
//══════════════════════════════════════════════════════════

//──────────────────────────────────────────────────────────────────────
//──  BOTON NORMAL
//──────────────────────────────────────────────────────────────────────
//── Lectura de un pulsador normal
//── A la salida se obtiene la señal de estado y los eventos:
//──   * Botón apretado
//──   * Botón liberado
//──────────────────────────────────────────────────────────────────────
module display7seg (
    input logic [7:0] seg_in,  //-- Estado de los segmentos (log. positiva)
    input logic [1:0] sel_in,  //-- Seleccion del display (0-3) a usar

    //-- Conexion con los pines del 7seg
    output logic [7:0] segments_out,
    output logic [3:0] display_sel_out
);

    //-- Mapear las señales del usuario a las reales
    //-- Conexion con el display
    assign segments_out = ~seg_in;

    //-- Decodificador de 2 a 4, negado
    assign display_sel_out = ~(1 << sel_in);

endmodule


//─────────────────────────────────────────────
//──  CONVESOR DE BCD A 7 SEGMENTOS
//─────────────────────────────────────────────
module bcd_to_7seg (
    input logic [3:0] bcd_in,
    output logic [7:0] disp_out
);

//-- Resultado intermedio
reg [7:0] d7seg;
always_comb begin
    case (bcd_in)
        4'h0: d7seg = 8'h3F;
        4'h1: d7seg = 8'h06;
        4'h2: d7seg = 8'h5B;
        4'h3: d7seg = 8'h4F;
        4'h4: d7seg = 8'h66;
        4'h5: d7seg = 8'h6D;
        4'h6: d7seg = 8'h7D;
        4'h7: d7seg = 8'h07;
        4'h8: d7seg = 8'h7F; 
        4'h9: d7seg = 8'h6F;
        4'hA: d7seg = 8'h77;
        4'hB: d7seg = 8'h7C;
        4'hC: d7seg = 8'h39;
        4'hD: d7seg = 8'h5E;
        4'hE: d7seg = 8'h79;
        4'hF: d7seg = 8'h71; 
        default: d7seg = 8'h00; 
    endcase
end 


//-- Devolver resultado
assign disp_out = d7seg;

endmodule


//─────────────────────────────────────────────
//──  GENERADOR DE LETRAS PARA DISPLAY DE 7 SEG
//─────────────────────────────────────────────
module disp_letter (
    input logic [4:0] code_in,
    output logic [7:0] letter_out
);
  
logic [7:0] letter;   //-- Letra a enviar al display
always_comb begin
    case (code_in)
        0: letter = 8'h77;  //-- 'A'
        1: letter = 8'h7C;  //-- 'B'
        2: letter = 8'h39;  //-- 'C'
        3: letter = 8'h5E;  //-- 'D'
        4: letter = 8'h79;  //-- 'E'
        5: letter = 8'h71;  //-- 'F'
        6: letter = 8'h7B;  //-- 'G'
        7: letter = 8'h76;  //-- 'H'
        8: letter = 8'h30;  //-- 'I'
        9: letter = 8'h1E;  //-- 'J'
        10: letter = 8'h70;  //-- 'K'
        11: letter = 8'h38;  //-- 'L'
        12: letter = 8'h55;  //-- 'M'
        13: letter = 8'h54;  //-- 'N'
        14: letter = 8'h3F;  //-- 'O'
        15: letter = 8'h73;  //-- 'P'
        16: letter = 8'h67;  //-- 'Q'
        17: letter = 8'h50;  //-- 'R'
        18: letter = 8'h6D;  //-- 'S'
        19: letter = 8'h78;  //-- 'T'
        20: letter = 8'h3E;  //-- 'U'
        21: letter = 8'h3E;  //-- 'V'
        22: letter = 8'h4F;  //-- 'W'
        23: letter = 8'h76;  //-- 'X'
        24: letter = 8'h6E;  //-- 'Y'
        25: letter = 8'h5B;  //-- 'Z'
        26: letter = 8'h00;  //-- ' '
        default: letter = 8'hFF;
    endcase;
end

//-- Devolver resultado
assign letter_out = letter;

endmodule

