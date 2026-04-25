`default_nettype none   

//-- Secuencia en los leds

module led_seq2 (
    input clk,
    output wire [15:0] leds
);

    //-- Contador
    reg [26:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Numero de secuencia
    wire [1:0] seq_num;
    assign seq_num = counter[26:25];

    //-- Secuencia de 4 estados
    assign leds = 
        (seq_num == 2'b00) ? 16'h000F :
        (seq_num == 2'b01) ? 16'h00F0 :
        (seq_num == 2'b10) ? 16'h0F00 :
                             16'hF000;

endmodule
