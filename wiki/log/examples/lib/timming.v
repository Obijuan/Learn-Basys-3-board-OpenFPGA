//══════════════════════════════════════════════════════════
//─ Bibloteca de modulos para TEMPORIZACION
//══════════════════════════════════════════════════════════

//─────────────────────────────────────
//──  PRESCALER DE N BITS
//─────────────────────────────────────
module prescaler (
    input wire clk,

    output wire signal,  //-- Señal cuadrada de salida
    output wire done    //-- Tic de periodo 
);

//-- Parametro: Numero de bits del prescaler
parameter N = 20;

//-- Registro del prescaler
reg [N-1:0] value = 0;
always @(posedge clk) begin
    value <= value + 1;
end

//-- Cuando esta todo a 1s ha llegado a su valor
//-- maximo, y en el siguiente ciclo comienza un
//-- periodo nuevo
assign done = |value;

//-- Asignar la salida
assign signal = value[N-1];

endmodule
