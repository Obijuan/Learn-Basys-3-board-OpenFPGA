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
