`default_nettype none   

//-- Mostrar el estado de un pulsador en un led
//-- El boton central se muestra en el LED 15

module leds_buttons (
    input wire [4:0] buttons, 
    output wire [4:0] leds
);

//-- Sacar los botones por los leds
assign leds = buttons;

endmodule
