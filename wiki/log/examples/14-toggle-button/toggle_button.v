`default_nettype none   

//-- Cambiar de estado el LED 15 cuando
//-- se aprieta el boton central
module toggle_button (
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

//--- Antirrebotes
wire button;
debounce  #(
    .SIZE(20)
) u_debounce (
    .clk(clk),
    .value_in(button_sync),
    .value_out(button)
);
 
//-- Botón apretado
//-- (Rebotes eliminados)
wire button_press;
posedge_detector u_pos_detector (
    .clk(clk),
    .value(button),
    .pos_edge(button_press)
);


//-- Biestable T
reg state;
always @(posedge clk) begin
    if (button_press)
        state <= ~state; 
end

//-- Mostrar el biestable T en el LED
assign leds[15] = state;

endmodule

