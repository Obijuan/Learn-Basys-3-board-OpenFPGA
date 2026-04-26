`default_nettype none   

//-- Movimiento de un cursor en los LEDs
//-- con los botones izquierda-derecha
//-- El cursor es un LED encendido
module cursor_buttons (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);


//--------------------------------------------
//-- PULSADORES
//--------------------------------------------
wire butt_izq; 
wire butt_der;
wire butt_izq_press;
wire butt_der_press;
button_input u_btn_izq (
    .clk(clk),
    .button_pin_in(buttons[2]),  //-- Pulsador izquierdo
    .button_state_out(butt_izq),
    .press_out(butt_izq_press),
    .release_out()  //-- Sin conectar
);

button_input u_btn_der (
    .clk(clk),
    .button_pin_in(buttons[3]),  //-- Pulsador derecho
    .button_state_out(butt_der),
    .press_out(butt_der_press),
    .release_out()  //-- Sin conectar
);

//-- Registro que almacena el contenido de los LEDs
//-- Es una patalla 1x16: 1 file de 16 posiciones
reg [15:0] screen = 15'h0080;
always @(posedge clk) begin

    //-- Boton derecho: Desplazamiento a la derecha
    if (butt_der_press)
        screen <= {screen[0], screen[15:1]};

    //-- Boton izquierdo: Desplazamiento a la izquierda
    else if (butt_izq_press)
        screen <= {screen[14:0], screen[15]};
end


//-- Refrescar la pantalla
assign leds = screen;


endmodule

