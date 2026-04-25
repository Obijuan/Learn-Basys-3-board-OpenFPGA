`default_nettype none   

//-- Desplazamiento de un led hacia la izquierda

module led_walking (
    input clk,
    output wire [15:0] leds
);

    //-- Bits del contador
    localparam N = 25;

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

    //-- Registro de desplazamiento hacia la izquierda de 16 bits
    reg [15:0] shift_reg = 15'h1;
    always @(posedge clk) begin

        //-- Solo funciona en el tic que se alcanza
        //-- el valor maximo del contador
        if (max) begin
            shift_reg <= {shift_reg[14:0], shift_reg[15]};
        end
    end

    //-- Mostrar el registro de desplazamiento en los leds
    assign leds = shift_reg;

endmodule
