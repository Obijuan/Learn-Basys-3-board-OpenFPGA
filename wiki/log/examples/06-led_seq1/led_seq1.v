`default_nettype none   

//-- Secuencia en los leds

module led_seq1 (
    input clk,
    output wire [15:0] leds
);

    //-- Contador de 25 bits
    reg [25:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Multiplexor para mostrar los
    //-- estados de la secuencia
    assign leds = (counter[25]) ? 16'hAAAA : 16'h5555;

endmodule
