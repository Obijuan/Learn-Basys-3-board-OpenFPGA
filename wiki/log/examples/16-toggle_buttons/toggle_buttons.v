`default_nettype none   

//-- Convertir todos los botones en botones de cambio
//-- Mostrar su estado en los leds
module toggle_buttons (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Señales de los pulsadores listas para usarse
wire [4:0] button_state;  //-- Estado del pulsador
wire [4:0] press;         //-- Tic de pulsado
reg [4:0] btn_toggle = 5'h0;    //-- Estado de los pulsadores de cambio (TFFs)

//-- Procesar boton 0
button_input u_butt0 (
    .clk(clk),
    .button_pin_in(buttons[0]),
    .button_state_out(button_state[0]),
    .press_out(press[0]),
    .release_out()  //-- Sin conectar
);

//-- Procesar boton 1
button_input u_butt1 (
    .clk(clk),
    .button_pin_in(buttons[1]),
    .button_state_out(button_state[1]),
    .press_out(press[1]),
    .release_out()  //-- Sin conectar
);

//-- Procesar boton 2
button_input u_butt2 (
    .clk(clk),
    .button_pin_in(buttons[2]),
    .button_state_out(button_state[2]),
    .press_out(press[2]),
    .release_out()  //-- Sin conectar
);

//-- Procesar boton 3
button_input u_butt3 (
    .clk(clk),
    .button_pin_in(buttons[3]),
    .button_state_out(button_state[3]),
    .press_out(press[3]),
    .release_out()  //-- Sin conectar
);

//-- Procesar boton 4
button_input u_butt4 (
    .clk(clk),
    .button_pin_in(buttons[4]),
    .button_state_out(button_state[4]),
    .press_out(press[4]),
    .release_out()  //-- Sin conectar
);


//-- Biestables T para pulsador 0
always @(posedge clk) begin
    if (press[0])
        btn_toggle[0] <= ~btn_toggle[0]; 
end

//-- Biestables T para pulsador 1
always @(posedge clk) begin
    if (press[1])
        btn_toggle[1] <= ~btn_toggle[1]; 
end

//-- Biestables T para pulsador 2
always @(posedge clk) begin
    if (press[2])
        btn_toggle[2] <= ~btn_toggle[2]; 
end

//-- Biestables T para pulsador 3
always @(posedge clk) begin
    if (press[3])
        btn_toggle[3] <= ~btn_toggle[3]; 
end

//-- Biestables T para pulsador 4
always @(posedge clk) begin
    if (press[4])
        btn_toggle[4] <= ~btn_toggle[4]; 
end


//---- SALIDAS
assign leds[15] = btn_toggle[0];
assign leds[14] = btn_toggle[1];
assign leds[13] = btn_toggle[2];
assign leds[12] = btn_toggle[3];
assign leds[11] = btn_toggle[4];

endmodule

