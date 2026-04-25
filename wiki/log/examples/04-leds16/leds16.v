`default_nettype none   

//-- Mostrar un numero de 16 bits en los leds
module leds16 (
    output wire [15:0] leds
);

    localparam [15:0] VALUE = 16'hF355;

    //-- Mostrar numero en los leds
    assign leds = VALUE;

endmodule
