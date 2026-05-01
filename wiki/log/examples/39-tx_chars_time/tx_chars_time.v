`default_nettype none
`include "buttons.vh" 


//-- Transmitir automaticamente y a velocidad lenta las letras
//-- de la 'A' a la 'Z'
module tx_chars_time (
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

//────────────────────────────
//──  PRESCALER
//────────────────────────────
reg next;
prescaler #(
    .N(26)
) u_prescaler0 (
    .clk(clk),
    .signal(),
    .done(next)
);

//────────────────────────────────────────────
//── UART: TRANSMISOR
//────────────────────────────────────────────
//-- Instanciar la UART
wire transmit;
uart_tx_module u_uart_tx0 (
    .clk(clk),
    .start_in(transmit),
    .data_in(char),   

    .tx_pin_out(uart_tx),   
    .busy_out(),     
    .done_out()
);

//-- Contador: Caracteres desde 'A' a la 'Z'
reg [7:0] char = 8'h41;
wire reset;
always @(posedge clk) begin
    if (reset)
        char <= 8'h41;
    else if (transmit)
        char <= char + 1;
end

assign reset = (char == ("Z"+1));

//-- Realizar la transmision (bien automatica o bien manual)
assign transmit = next | btn_up_press;

//-- TEST
assign leds[15] = btn_up;
assign leds[7:0] = char;

endmodule
