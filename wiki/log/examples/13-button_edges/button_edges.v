`default_nettype none   

//-- Contar los flancos de subida en un pulsador
//-- (Incluidos los que llegan por rebotes)
module button_edges (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Poscion del boton central
localparam BTN_CENTER = 0;

//──────── Sincronizador para el pulsador
//── Pulsador sincronizado
wire button_sync;
synchronizer u_sync (
    .clk(clk),
    .async_in(buttons[BTN_CENTER]),
    .sync_out(button_sync)
);

//──────── Detectar flancos en el pulsador
wire button_action;
edge_detector u_edge (
    .clk(clk),
    .value(button_sync),
    .tic(button_action)
);

//-- Contador de pulsaciones y liberaciones
//-- (Cuenta también los rebotes)
reg [15:0] cont;
always @(posedge clk) begin
    if (button_action)
      cont <= cont + 1; 
end

//-- Mostrar el contador en los leds
assign leds = cont;

endmodule

