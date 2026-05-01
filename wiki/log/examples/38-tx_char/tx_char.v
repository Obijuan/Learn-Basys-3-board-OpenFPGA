`default_nettype none
`include "buttons.vh" 


//-- Transmitir el carácter 'A' al apretar el pulsador
module tx_char (
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
//── PULSADORES
//────────────────────────────────────────────
wire btn_up;
wire btn_up_press;
normal_button u_btn0 (
    .clk(clk),
    .btn_pin(buttons[BTN_UP]),  
    .btn_state(btn_up),
    .tic_press(btn_up_press),
    .tic_release(),
);


//-- Instanciar la UART
uart_tx_module u_uart_tx0 (
    .clk(clk),
    .start_in(btn_up_press),
    .data_in("A"),   

    .tx_pin_out(uart_tx),   
    .busy_out(),     
    .done_out()
);


//-- TEST
assign leds[15] = btn_up;


endmodule
