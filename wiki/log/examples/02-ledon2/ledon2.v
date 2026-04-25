`default_nettype none   

//-- Encender dos leds
module ledon2 (
    output wire [1:0] leds
);

    //-- Encender los dos leds
    assign leds = 2'b11;

endmodule
