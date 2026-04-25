`default_nettype none   

//-- Mostrar el estado de un pulsador en un led
//-- El boton central se muestra en el LED 15

module led_button (
    input clk,
    input wire button,
    output wire led,
);

assign led = button;

endmodule
