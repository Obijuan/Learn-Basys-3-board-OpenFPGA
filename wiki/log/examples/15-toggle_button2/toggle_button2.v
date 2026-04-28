`default_nettype none
`include "buttons.vh"   

//-- Cambiar de estado el LED 15 cuando
//-- se aprieta el boton central
module toggle_button2 (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Señales del pulsador
wire btn_toggle;

toggle_button u_toggle0 (
    .clk(clk),
    .btn_pin(buttons[BTN_CENTER]),
    .btn_state(btn_toggle),
    .tic_change(),  //-- No usado
);

//-- Mostrar el pulsador de cambio
assign leds[15] = btn_toggle;

endmodule

