module top(
    input logic clk,

    //-- LEDs
    output logic [15:0] leds
);

//-- Conexion a los leds
logic [15:0] led_o;

//-- Instanciar el interfaz
simple_bus mi_bus();

//-- Interconectar el maestro y el esclavo a través del bus
master_mod u_maestro (
    .bus_if(mi_bus)
);

slave_mod  u_esclavo (
    .clk(clk),
    .bus_if(mi_bus),
    .data_out(led_o)
);

//-- Mostrar en los LEDs
assign leds = led_o;

endmodule




