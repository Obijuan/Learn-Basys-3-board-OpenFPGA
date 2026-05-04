//══════════════════════════════════════════════════════════
//─ Bibloteca de modulos para TEMPORIZACION
//══════════════════════════════════════════════════════════

//─────────────────────────────────────
//──  PRESCALER DE N BITS
//─────────────────────────────────────
module prescaler (
    input logic clk,

    output logic signal,  //-- Señal cuadrada de salida
    output logic done    //-- Tic de periodo 
);

//-- Parametro: Numero de bits del prescaler
parameter N = 20;

//-- Registro del prescaler
logic [N-1:0] value = 0;
always_ff @(posedge clk) begin
    value <= value + 1;
end

//-- Cuando esta todo a 1s ha llegado a su valor
//-- maximo, y en el siguiente ciclo comienza un
//-- periodo nuevo
assign done = &value;

//-- Asignar la salida
assign signal = value[N-1];

endmodule


//─────────────────────────────────────
//──  PRESCALER DE N BITS
//──  Salida de 2 bits
//─────────────────────────────────────
module prescaler2 (
    input logic clk,
    output logic [1:0] signal   //-- Señal cuadrada de salida
);

//-- Parametro: Numero de bits del prescaler
parameter N = 20;

//-- Registro del prescaler
logic [N-1:0] value = 0;
always_ff @(posedge clk) begin
    value <= value + 1;
end

//-- Asignar la salida
assign signal = value[N-1:N-2];

endmodule

