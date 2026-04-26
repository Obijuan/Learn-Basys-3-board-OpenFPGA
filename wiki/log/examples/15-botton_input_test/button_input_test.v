`default_nettype none   

//-- Cambiar de estado el LED 15 cuando
//-- se aprieta el boton central
module button_input_test (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Señales de los pulsadores listas para usarse
wire [4:0] button_state;  //-- Estado del pulsador
wire [4:0] press;         //-- Tic de pulsado

//-- Procesar boton 0
button_input u_butt0 (
    .clk(clk),
    .button_pin_in(buttons[0]),
    .button_state_out(button_state[0]),
    .press_out(press[0]),
    .release_out()  //-- Sin conectar
);


//-- Convertir el pulsador en uno de cambio
reg btn_toggle = 0;
always @(posedge clk) begin
    if (press[0])
        btn_toggle <= ~btn_toggle; 
end

//-- Mostrar el pulsador de cambio
assign leds[15] = btn_toggle;

//-- Mostrar el estado del pulsador
assign leds[14] = button_state[0];

endmodule

