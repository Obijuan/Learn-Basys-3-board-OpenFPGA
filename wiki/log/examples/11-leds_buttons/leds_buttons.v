`default_nettype none   

//-- Mostrar el estado de un pulsador en un led
//-- El boton central se muestra en el LED 15

module leds_buttons (
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Sacar los botones por los leds
assign leds[15:11] = buttons;


//-- BUG!
//-- Si se asignan valores a los leds restantes
//-- se obtiene este error
//-- ERROR: Invalid global constant node 'INT_L_X0Y3/GND_WIRE'
//assign leds[10:0] = 11'h0;

endmodule
