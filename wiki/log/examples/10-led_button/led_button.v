`default_nettype none   

//-- Mostrar el estado de un pulsador en un led
//-- El boton central se muestra en el LED 15

module led_button (
    input wire [4:0] buttons,
    output wire [15:0] leds,
);

assign leds[15] = buttons[0];

endmodule
