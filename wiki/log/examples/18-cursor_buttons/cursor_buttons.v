`default_nettype none  
`include "buttons.vh" 

//-- Movimiento de un cursor en los LEDs
//-- con los botones izquierda-derecha
//-- El cursor es un LED encendido
module cursor_buttons (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);


//──────── PROCESAR PULSADORES
wire btn_izq; 
wire bn_der;
wire btn_izq_press;
wire btn_der_press;

normal_button u_btn_izq(
    .clk(clk),
    .btn_pin(buttons[BTN_LEFT]),  
    .btn_state(),   //-- No usado
    .tic_press(btn_izq_press),
    .tic_release(),  //-- No usado
);

normal_button u_btn_der(
    .clk(clk),
    .btn_pin(buttons[BTN_RIGHT]),  
    .btn_state(),   //-- NO usado
    .tic_press(btn_der_press),
    .tic_release(),  //-- No usado
);


//-- Registro que almacena el contenido de los LEDs
//-- Es una patalla 1x16: 1 file de 16 posiciones
reg [15:0] screen = 15'h0080;
always @(posedge clk) begin

    //-- Boton derecho: Desplazamiento a la derecha
    if (btn_der_press)
        screen <= {screen[0], screen[15:1]};

    //-- Boton izquierdo: Desplazamiento a la izquierda
    else if (btn_izq_press)
        screen <= {screen[14:0], screen[15]};
end


//-- Refrescar la pantalla
assign leds = screen;


endmodule

