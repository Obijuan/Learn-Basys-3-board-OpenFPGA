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
    input wire [7:0] seg_in,  //-- Estado de los segmentos (log. positiva)
    input wire [1:0] sel_in,  //-- Seleccion del display (0-3) a usar

    //-- Conexion con los pines del 7seg
    output wire [7:0] segments_out,
    output wire [3:0] display_sel_out
);

    //-- Mapear las señales del usuario a las reales
    //-- Conexion con el display
    assign segments_out = ~seg_in;

    //-- Decodificador de 2 a 4, negado
    assign display_sel_out = ~(1 << sel_in);

endmodule


//──────────────────────────────────────────────────────────────────────
//──  CONVESOR DE BCD A 7 SEGMENTOS
//──────────────────────────────────────────────────────────────────────
module bcd_to_7seg (
    input wire [3:0] bcd_in,
    output wire [7:0] disp_out
);

//-- Resultado intermedio
reg [7:0] d7seg;
always @* begin
    case (bcd_in)
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

//-- Devolver resultado
assign disp_out = d7seg;

endmodule

