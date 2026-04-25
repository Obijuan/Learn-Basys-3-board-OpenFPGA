`default_nettype none   

//-- Cambiar de estado un led con un pulsador
module toggle_led (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//------- Sincronizador para el pulsador
//-- Pulsador sincronizado
wire button_sync;
synchronizer u_sync (
    .clk(clk),
    .async_in(buttons[0]),
    .sync_out(button_sync)
);

//-- Sacar el valor por el led
assign leds[15] = button_sync;

endmodule

