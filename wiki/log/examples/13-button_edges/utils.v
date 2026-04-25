//--------------------------------------
//-- Cajon de sastre
//--------------------------------------


//----------------------------------------
//-- Detector de flancos de subida
//----------------------------------------
module posedge_detector (
    input wire clk,

    //-- Valor de entrad
    input wire value,

    //-- Flanco detectado
    output wire pos_edge
);

//-- Valor en el siguiente ciclo
reg value_r;
always @( posedge clk ) begin
    value_r <= value;
end

assign pos_edge = ~value_r & value;

endmodule


//-------------------------------------------
//-- Detector de flancos de subida y bajada
//-------------------------------------------
module edge_detector(
    input wire clk,

    //-- Valor de entrad
    input wire value,

    //-- Flanco detectado
    output wire edges
);

//-- Valor en el siguiente ciclo
reg value_r;
always @( posedge clk ) begin
    value_r <= value;
end

assign edges = value ^ value_r;

endmodule


//------------------------------------------
//-- Sincronizador de pines de entrada
//------------------------------------------
module synchronizer(
    input wire clk,
    input wire async_in,
    output wire sync_out
);
    reg [1:0] stages;
    always @(posedge clk) begin
        stages <= { stages[0], async_in };
    end

    assign sync_out = stages[1];
endmodule

