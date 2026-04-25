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


//------------------------------------------------
//-- Antirrebotes
//------------------------------------------------
module debounce (
    input wire clk,
    input wire value_in,
    output reg value_out
);

parameter SIZE = 17;

wire timeout;
reg bounce_cnt_state;
wire edges;

always @( posedge clk ) begin
    if (timeout)
        value_out <= value_in;
end

reg [SIZE-1:0] bounce_cnt;

always @( posedge clk ) begin
    if (bounce_cnt_state==0)
        bounce_cnt <= 0;
    else bounce_cnt <= bounce_cnt + 1;
end

assign timeout = bounce_cnt[SIZE-1];


wire start_cnt;
wire stop_cnt;
always @( posedge clk ) begin
    if (start_cnt)
        bounce_cnt_state = 1;
    else if (stop_cnt)
        bounce_cnt_state = 0;
end
assign stop_cnt = timeout;
assign start_cnt = edges;


edge_detector u_sw1_edges (
    .clk(clk),
    .value(value_in),
    .edges(edges)
);

endmodule
