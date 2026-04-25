`default_nettype none   

//-- Cambiar de estado un led con un pulsador
module toggle_led (
    input wire clk, 
    input wire button, 
    output wire led
);

//------- Sincronizador para el pulsador
//-- Pulsador sincronizado
wire button_sync;
synchronizer u_sync (
    .clk(clk),
    .async_in(button),
    .sync_out(button_sync)
);

//-- Sacar el valor por el led
assign led = button_sync;

endmodule

