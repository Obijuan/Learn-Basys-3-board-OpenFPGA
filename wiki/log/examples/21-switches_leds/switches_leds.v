`default_nettype none   


module switches_leds (
    input wire clk, 
    input wire [4:0] buttons,
    input wire [15:0] switches, 
    output wire [15:0] leds
);

//-- Mostrar los switches en los leds
assign leds = switches;

endmodule

