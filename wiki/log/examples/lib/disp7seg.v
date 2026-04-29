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



