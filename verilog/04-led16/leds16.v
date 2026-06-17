`default_nettype none   

//-- Show a 16-bit number on the LEDs
module main (
    output wire [15:0] leds
);

    localparam [15:0] VALUE = 16'hF355;

    //-- Mostrar numero en los leds
    assign leds = VALUE;

endmodule
