`default_nettype none   

//-- Led parpadeante
module blinky (
    input clk,
    output wire [15:0] leds
);

    //-- Contador de 25 bits
    reg [24:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Mostrar en el LED0 el bit de mayor peso del contador
    assign leds[0] = counter[24];

endmodule
