`default_nettype none   


module switch_led (
    input wire clk, 
    input wire [4:0] buttons,
    input wire [15:0] switches, 
    output wire [15:0] leds
);

//-- Mostrar el siwtch 0 en el led 15
assign leds[15] = switches[0];

endmodule

