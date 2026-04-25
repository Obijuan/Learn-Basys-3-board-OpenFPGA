`default_nettype none   

//-- Movimiento del led como un zylon
//-- (Coche fantastico)

module led_cylon (
    input clk,
    output wire [15:0] leds
);

    //-- Bits del contador
    localparam N = 24;

    //-- Contador
    reg [N-1:0] counter;
    always @(posedge clk) begin
        if (counter[N-1])
            counter <= 0;
        else
            counter <= counter + 1;
    end

    //-- Señal que indica que el contador ha llegado a su 
    //-- valor maximo
    wire max;
    assign max = counter[N-1];

    //-- El led ha alcanzado el tope izquierdo
    wire left_end;
    assign left_end = shift_reg[15];

    //-- El led ha alcanzado el tope derecho
    wire right_end;
    assign right_end = shift_reg[0];

    //-- Biestable que indica el sentido actual
    reg sentido = 1; //-- Arrancamos yendo hacia la izquierda
    always @(posedge clk) begin

        //-- Cambio de sentido a la derecha
        if (sentido == 1 && left_end)
            sentido <= 0;
        else if (sentido == 0 && right_end)
            sentido <= 1;
    end

    //-- Registro de desplazamiento izquierda-derecha
    reg [15:0] shift_reg = 15'h1;
    always @(posedge clk) begin

        //-- Solo funciona en el tic que se alcanza
        //-- el valor maximo del contador
        if (max) begin

            //-- Segun el sentido se desplaza hacia un lado
            //-- o hacia otro
            if (sentido == 1)  //-- Sentido: Izquierda
                shift_reg <= {shift_reg[14:0], 1'b0};
            else //-- sentido: derecha
                shift_reg <= {1'b0, shift_reg[15:1]};
        end
    end

    //-- Mostrar el registro de desplazamiento en los leds
    assign leds = shift_reg;

endmodule
