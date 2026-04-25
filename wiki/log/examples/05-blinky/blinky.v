`default_nettype none   

//-- Led parpadeante
module blinky (
    input clk,
    output wire led
);
    //-- Numero de led a hacer parpadear
    localparam N = 15;

    //-- Contador de 25 bits
    reg [24:0] counter;
    always @(posedge clk) begin
        counter <= counter + 1;
    end

    //-- Mostrar en el led el bit de mayor peso del contador
    assign led = counter[24];

endmodule
