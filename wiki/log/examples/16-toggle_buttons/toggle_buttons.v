`default_nettype none 
`include "buttons.vh"   

//-- Convertir todos los botones en botones de cambio
//-- Mostrar su estado en los leds
module toggle_buttons (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Pulsadores de cambio
wire [4:0] btn_toggle;

toggle_button u_toggle0 (
    .clk(clk),
    .btn_pin(buttons[BTN_CENTER]),
    .btn_state(btn_toggle[BTN_CENTER]),
    .tic_change(),  //-- No usado
);

toggle_button u_toggle1 (
    .clk(clk),
    .btn_pin(buttons[BTN_UP]),
    .btn_state(btn_toggle[BTN_UP]),
    .tic_change(),  //-- No usado
);

toggle_button u_toggle2 (
    .clk(clk),
    .btn_pin(buttons[BTN_DOWN]),
    .btn_state(btn_toggle[BTN_DOWN]),
    .tic_change(),  //-- No usado
);

toggle_button u_toggle3 (
    .clk(clk),
    .btn_pin(buttons[BTN_LEFT]),
    .btn_state(btn_toggle[BTN_LEFT]),
    .tic_change(),  //-- No usado
);


toggle_button u_toggle4 (
    .clk(clk),
    .btn_pin(buttons[BTN_RIGHT]),
    .btn_state(btn_toggle[BTN_RIGHT]),
    .tic_change(),  //-- No usado
);

//---- SALIDAS
assign leds[15] = btn_toggle[BTN_CENTER];
assign leds[14] = btn_toggle[BTN_UP];
assign leds[13] = btn_toggle[BTN_LEFT];
assign leds[12] = btn_toggle[BTN_RIGHT];
assign leds[11] = btn_toggle[BTN_DOWN];

endmodule

