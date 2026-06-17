`default_nettype none   

//-- Turn on one LED
module ledon (

    //-- LEDs de la BASYS3
    output wire [15:0] leds
);

    //-- Encender led15!
    assign leds[15] = 1'b1;

endmodule

