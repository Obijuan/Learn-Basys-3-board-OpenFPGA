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
reg [4:0] btn_toggle;

//------- Instanciar modulos para los N botones

//-- Numero de modulo a instanciar
genvar i;

generate

    //-- Para cada pulsador...
    for (i = 0; i < N; i = i + 1) begin : inst_toggle_button

        //-- Instanciar modulo de acceso al pulsador i
        toggle_button u_toggle0 (
            .clk(clk),
            .btn_pin(buttons[i]),
            .btn_state(btn_toggle[i]),
            .tic_change(),  //-- No usado
        );


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

