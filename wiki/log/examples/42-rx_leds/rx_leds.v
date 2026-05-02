`default_nettype none
`include "buttons.vh" 


//-- Recibir un caracter por el puerto serie y 
//-- mostrarlo en los LEDs
module rx_leds (
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
    input wire uart_rx_async,
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

//────────────────────────────────────────────
//──  MAIN
//────────────────────────────────────────────

//─── Control del LED0 con '0'
reg led0 = 0;
wire is_0;
always @(posedge clk) begin
    if (done && is_0)
        led0 <= ~led0; 
end

assign is_0 = (car == "0");
assign leds[0] = led0;

//─── Control del LED1 con '1'
reg led1 = 0;
wire is_1;
always @(posedge clk) begin
    if (done && is_1)
        led1 <= ~led1; 
end

assign is_1 = (car == "1");
assign leds[1] = led1;




//────────────────────────────────────────────
//──  ELIMINAR WARNINGS
//────────────────────────────────────────────
//-- Conexion de las señales de salida NO USADAS
//-- para eliminar los warnings

//-- Puerto serie
assign uart_tx = 1;

//-- VGA
assign vga_red = 4'h0;
assign vga_blue = 4'h0;
assign vga_green = 4'h0;
assign vga_hsync = 0;
assign vga_vsync = 0;

//-- DISPLAY 7seg
assign segments = 8'hF;
assign display_sel = 4'hF;

endmodule
