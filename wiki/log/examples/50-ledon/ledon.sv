//-- Encender un LED
//-- Ejemplo en system verilog

module ledon(
    output logic [15:0] leds
);

assign leds[0] = 1;

endmodule

