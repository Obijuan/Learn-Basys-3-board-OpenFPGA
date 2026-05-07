module top(
    input logic clk,

    //-- BOTONES
    input logic [4:0] buttons,

    //-- Switches
    input  logic [15:0] switches,

    //-- LEDs
    output logic [15:0] leds,

    //-- Display 7 segmentos
    output logic [7:0] segments,
    output logic [3:0] display_sel,
    
    //-- Puerto serie
    input  logic uart_rx_async,
    output logic uart_tx
);


//───────────────────────────────────────────────────────────
//──         MICROCONTROLADOR 
//───────────────────────────────────────────────────────────
import constants::SYS_CLK_FREQ_MHZ;
import constants::UART_BAUD_RATE;
import constants::DEBOUNCER_SIZE;

logic clk_50Mhz;
logic clk_25Mhz;
logic [1:0] cnt;
always_ff @(posedge clk) begin
   cnt <= cnt + 1; 
end

//-- Generar relojes de diferentes frecuencias
assign clk_50Mhz = cnt[0];
assign clk_25Mhz = cnt[1];

mcu #(
    .CLK_FREQUENCY_MHZ(SYS_CLK_FREQ_MHZ),
    .UART_BAUD_RATE(UART_BAUD_RATE),
    .DEBOUNCER_SIZE(DEBOUNCER_SIZE)
) u_mcu (
    //-- Main system clk
    .clk(clk_25Mhz),

    //-- Memory clock
    .clk_mem(~clk_25Mhz),

    //-- LEDs
    .leds(leds),

    //-- Buttons 
    .buttons_async(buttons),

    //-- Switches
    .switches_async(switches),

    //-- Display 7 segmentos
    .segments(segments),
    .segments_select(display_sel),

    //-- SERIAL PORT
    .uart_tx(uart_tx),
    .uart_rx_async(uart_rx_async)
);

endmodule
