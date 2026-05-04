module top(
    input logic clk,

    //-- LEDs
    output logic [15:0] leds,

    //-- BOTONES
    input logic [4:0] buttons,

    //-- Switches
    input  logic [15:0] switches,
    
    //-- SERIAL PORT
    input  logic uart_rx_async,
    output logic uart_tx
);


//───────────────────────────────────────────────────────────
//──         MICROCONTROLADOR 
//───────────────────────────────────────────────────────────
import constants::SYS_CLK_FREQ_MHZ;
import constants::UART_BAUD_RATE;
import constants::DEBOUNCER_SIZE;

mcu #(
    .CLK_FREQUENCY_MHZ(SYS_CLK_FREQ_MHZ),
    .UART_BAUD_RATE(UART_BAUD_RATE),
    .DEBOUNCER_SIZE(DEBOUNCER_SIZE)
) u_mcu (
    //-- Main system clk
    .clk(clk),

    //-- Memory clock
    .clk_mem(~clk),

    //-- LEDs
    .leds(leds),

    //-- Buttons 
    .buttons_async(buttons)
);

//-- ELIMINAR LOS WARNINGS
assign uart_tx = 1'b1;

endmodule

