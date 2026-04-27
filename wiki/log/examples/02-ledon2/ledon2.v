`default_nettype none   

//-- Encender dos leds
module ledon2 (
    output wire [1:0] leds
);

    //-- Encender los dos leds D0 y D1
    assign leds = 2'b11;

endmodule
