`default_nettype none   

//-- Mostrar el estado de un pulsador en un led
//-- El boton central se muestra en el LED 15

module leds_buttons (
    input wire [4:0] buttons,  //-- Centro

    output wire led11,
    output wire led12,
    output wire led13, 
    output wire led14,
    output wire led15
);

assign led11 = buttons[4]; //-- Abajo
assign led12 = buttons[3]; //-- Derecha
assign led13 = buttons[2]; //-- Izquierda
assign led14 = buttons[1]; //-- Arriba
assign led15 = buttons[0]; //-- Centro

endmodule
