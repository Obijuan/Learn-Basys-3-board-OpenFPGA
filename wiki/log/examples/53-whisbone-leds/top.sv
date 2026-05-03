module top(
    input logic clk,

    //-- BOTONES
    input wire [4:0] buttons,

    //-- LEDs
    output logic [15:0] leds
);

//-- Conexion a los leds
logic [15:0] led_o;

//-- Instanciar interfaz para wishbone
wishbone_interface wb_if();

//-- Instanciar los LEDs
wishbone_leds #(
    .ADDRESS(32'h0008_0000),
    .SIZE(1)
) u_wishbone_leds (
    .clk(clk),
    .rst(buttons[0]), 
    .leds(led_o),
    .wishbone(wb_if)
);

//-- Escribir un valor en los LEDs
assign wb_if.adr = 32'h0008_0000;
assign wb_if.cyc = 1;
assign wb_if.we  = 1;
assign wb_if.sel = 4'b0011;
assign wb_if.stb = 1;

//-- Seleccionar con pulsador el valor a escribir
//-- en los leds, a través del wishbone
always_comb begin : mux
    if (buttons[1])
        wb_if.dat_mosi = 32'h0000_AAAA;
    else 
        wb_if.dat_mosi = 32'h0000_5555;
end

//-- Mostrar en los LEDs
assign leds = led_o;

endmodule

