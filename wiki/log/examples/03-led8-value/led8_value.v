`default_nettype none   

//-- Mostrar un numero de 8 bits en los leds
module led8_value (
    output wire [7:0] leds
);

    localparam [7:0] VALUE = 8'hAA;

    //-- Mostrar numero en los leds
    assign leds = VALUE;

endmodule
