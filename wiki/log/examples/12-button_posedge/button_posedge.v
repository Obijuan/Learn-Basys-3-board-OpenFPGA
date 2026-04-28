`default_nettype none   

//-- Contar los flancos de subida en un pulsador CENTRAL
//-- (Incluidos los que llegan por rebotes)

module button_posedge (
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

//──────── Detectar flanco de subida en el pulsador
wire button_press;
posedge_detector u_posedge (
    .clk(clk),
    .value(button_sync),
    .tic(button_press)
);

//-- Contador de pulsaciones
//-- (Cuenta también los rebotes)
reg [15:0] cont;
always @(posedge clk) begin
    if (button_press)
      cont <= cont + 1; 
end

//-- Mostrar el contador en los leds
assign leds = cont;

endmodule

