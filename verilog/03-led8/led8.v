`default_nettype none   

//-- Show an 8-bit number on the LEDs
module main (
    output wire [7:0] leds
);

    //-- Valor a sacar por los leds
    localparam [7:0] VALUE = 8'hAA;

    //-- Mostrar numero en los leds
    assign leds = VALUE;

endmodule
