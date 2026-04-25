`default_nettype none   

//-- Mostrar el estado de un pulsador en un led
//-- El boton central se muestra en el LED 15

module leds_buttons (
    input wire button0,  //-- Centro
    input wire button1,  //-- Arriba
    input wire button2,  //-- Izquierda
    input wire button3,  //-- Derecha
    input wire button4,  //-- Abajo

    output wire led11,
    output wire led12,
    output wire led13, 
    output wire led14,
    output wire led15
);

assign led11 = button4;
assign led12 = button3;
assign led13 = button2;
assign led14 = button1;
assign led15 = button0;

endmodule
