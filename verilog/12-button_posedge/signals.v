//══════════════════════════════════════════════════════════
//─ Bibloteca de modulos para procesado basico de señales
//══════════════════════════════════════════════════════════


//──────────────────────────────────────────────────────────────────────
//──  SINCRONIZADOR
//──────────────────────────────────────────────────────────────────────
//── Estabilizar las señales de entrada, para evitar problemas
//── de metaestabilidad
//──────────────────────────────────────────────────────────────────────
module synchronizer(
    input wire clk,
    input wire async_in,  //-- Entrada asíncrona
    output wire sync_out  //-- Salida sincronizada
);

    //-- La señal se pasa por dos biestables en serie
    reg [1:0] stages;
    always @(posedge clk) begin
        stages <= { stages[0], async_in };
    end

    //-- Salida estabilizada
    assign sync_out = stages[1];
endmodule


//──────────────────────────────────────────────────────────────────────
//──  DETECTOR DE FLANCOS DE SUBIDA ↑
//──────────────────────────────────────────────────────────────────────
//── Detectar un flanco de subida en la señal de entrada
//── Se devuelve un 'tic' por cada flanco de subida detectado
//──────────────────────────────────────────────────────────────────────
module posedge_detector (
    input wire clk,

    //-- Valor de entrada
    input wire value,

    //-- Flanco de subida detectado
    output wire tic
);

//-- Valor en el siguiente ciclo
reg value_r;
always @( posedge clk ) begin
    value_r <= value;
end

//-- Hay flanco de subida si el valor actual es 1
//-- y el del ciclo anterior era 0
assign tic = ~value_r & value;

endmodule


//──────────────────────────────────────────────────────────────────────
//──  DETECTOR DE FLANCOS DE BAJADA ↓
//──────────────────────────────────────────────────────────────────────
//── Detectar un flanco de bajada en la señal de entrada
//── Se devuelve un 'tic' por cada flanco de bajada detectado
//──────────────────────────────────────────────────────────────────────
module negedge_detector (
    input wire clk,

    //-- Valor de entrad
    input wire value,

    //-- Flanco detectado
    output wire tic
);

//-- Valor en el siguiente ciclo
reg value_r;
always @( posedge clk ) begin
    value_r <= value;
end

//-- Hay flanco de bajada cuando el valor actual es 0 
//-- y el del ciclo anterior era 1
assign tic = value_r & ~value;

endmodule



//──────────────────────────────────────────────────────────────────────
//──  DETECTOR DE FLANCOS DE SUBIDA Y BAJADA ↑↓
//──────────────────────────────────────────────────────────────────────
//── Detectar un flanco, tanto de subida como bajada, en la 
//── señal de entrada. Se devuelve un 'tic' por cada flanco de detectado
//──────────────────────────────────────────────────────────────────────
module edge_detector(
    input wire clk,

    //-- Valor de entrad
    input wire value,

    //-- Flanco detectado
    output wire tic
);

//-- Valor en el siguiente ciclo
reg value_r;
always @( posedge clk ) begin
    value_r <= value;
end

//-- Hay flanco (de subida o bajada) cuando el valor
//-- actual es diferente al del ciclo anterior
assign tic = value ^ value_r;

endmodule


