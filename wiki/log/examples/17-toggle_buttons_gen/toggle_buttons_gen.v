`default_nettype none   

//-- Convertir todos los botones en botones de cambio
//-- Mostrar su estado en los leds
module toggle_buttons_gen (
    input wire clk, 
    input wire [4:0] buttons, 
    output wire [15:0] leds
);

//-- Numero de botones a usar como toggle
localparam N = 5;

//-- Señales de los pulsadores listas para usarse
wire [4:0] button_state;  //-- Estado del pulsador
wire [4:0] press;         //-- Tic de pulsado
reg [4:0] btn_toggle = 5'h0;    //-- Estado de los pulsadores de cambio (TFFs)

//------- Instanciar modulos para los N botones

//-- Numero de modulo a instanciar
genvar i;

generate

    //-- Para cada pulsador...
    for (i = 0; i < N; i = i + 1) begin : inst_button_input

        //-- Instanciar modulo de acceso a pulsador i
        button_input u_butt (
            .clk(clk),
            .button_pin_in(buttons[i]),
            .button_state_out(button_state[i]),
            .press_out(press[i]),
            .release_out()  //-- Sin conectar
        );

        //-- Conectar su salida a un biestable T
        always @(posedge clk) begin
            if (press[i])
                btn_toggle[i] <= ~btn_toggle[i]; 
        end

        //-- SALIDA
        //-- Conectar salidas biestable T a LEDs
        //-- Boton0 --> LED15
        //-- Boton1 --> LED14
        //-- ...
        //-- Boton4 --> LED11
        assign leds[15-i] = btn_toggle[i];

    end
endgenerate;

endmodule

