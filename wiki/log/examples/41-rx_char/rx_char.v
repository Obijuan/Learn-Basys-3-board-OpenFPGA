`default_nettype none
`include "buttons.vh" 


//-- Recibir un caracter por el puerto serie y 
//-- mostrarlo en los LEDs
module rx_char (
    input wire clk, 

    //-- BOTONES
    input wire [4:0] buttons,

    //-- SWITCHES
    input wire [15:0] switches,

    //-- LEDS 
    output wire [15:0] leds,

    //-- DIPLAY 7 SEGMENTOS
    output wire [7:0] segments,
    output wire [3:0] display_sel,

    //-- VGA
    output wire [3:0] vga_red,
    output wire [3:0] vga_blue,
    output wire [3:0] vga_green,
    output wire       vga_hsync,
    output wire       vga_vsync,

    //-- UART
    output wire uart_rx_async,
    output wire uart_tx
);
    

//────────────────────────────────────────────
//── UART: RECEPTOR
//────────────────────────────────────────────
wire [7:0] car;
wire done;
uart_rx_module u_uart_rx0 (
    .clk(clk),
    
    .rx_pin_in(uart_rx_async),
    .data_out(car), 
    .done_out(done)
);

//-- Conectar la salida del receptor a los LEDs
assign leds[15] = 1;
assign leds[7:0] = car;

//---------- No warnings
assign uart_tx = 1;

assign vga_red = 4'h0;
assign vga_blue = 4'h0;
assign vga_green = 4'h0;
assign vga_hsync = 0;
assign vga_vsync = 0;

assign segments = 8'hF;
assign display_sel = 4'hF;
endmodule
