`default_nettype none   
`include "buttons.vh"


//-- Cambiar de estado el LED 15 cuando
//-- se aprieta el boton central
module toggle_button (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//── Señales para el pulsador
wire btn_state;
wire btn_press;

//──────── PROCESAR PULSADOR
normal_button u_btn0(
    .clk(clk),
    .btn_pin(buttons[BTN_CENTER]),  
    .btn_state(btn_state),   
    .tic_press(btn_press),
    .tic_release(),  //-- No usado
);

//-- Conectar el pulsador a un biestable T
reg state;
always @(posedge clk) begin
    if (btn_press)
        state <= ~state; 
end

//-- Mostrar el biestable T en el LED
assign leds[15] = state;

endmodule

