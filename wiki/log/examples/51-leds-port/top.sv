module top(
    input logic clk,

    //-- BOTONES
    input wire [4:0] buttons,

    //-- LEDs
    output logic [15:0] leds
);

//-- Conexion a los leds
logic [15:0] led_o;

//-- Instanciar modulo
//-- Sacar un valor por el puerto
leds_port u1(
    .clk(clk),
    .rst(buttons[0]),

    .data_in(16'hAAAA),
    .wen(1'b1),

    .data_out(led_o)
);

//-- Sacar por los leds...
//-- Salida registrada
always_ff @( posedge clk ) begin : test
    leds <= led_o;
end


endmodule

