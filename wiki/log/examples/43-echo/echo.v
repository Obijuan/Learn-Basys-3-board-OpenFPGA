`default_nettype none
`include "buttons.vh" 


//-- Hacer de eco de todos los caracteres recibidos
module echo (
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
wire rcv_done;
uart_rx_module u_uart_rx0 (
    .clk(clk),
    
    .rx_pin_in(uart_rx_async),
    .data_out(car), 
    .done_out(rcv_done)
);

//────────────────────────────────────────────
//── UART: TRANSMISOR
//────────────────────────────────────────────
uart_tx_module u_uart_tx0 (
    .clk(clk),
    .start_in(rcv_done),
    .data_in(car),   

    .tx_pin_out(uart_tx),   
    .busy_out(),     
    .done_out()
);

//────────────────────────────────────────────
//──  MAIN
//────────────────────────────────────────────

//-- Capturar el caracter recibido y mandarlo a los leds
reg [7:0] data;
always @(posedge clk) begin
    if (rcv_done)
        data <= car;
end

assign leds[7:0] = data;


//────────────────────────────────────────────
//──  ELIMINAR WARNINGS
//────────────────────────────────────────────
//-- Conexion de las señales de salida NO USADAS
//-- para eliminar los warnings

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
