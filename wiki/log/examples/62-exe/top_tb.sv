module TB;

//------- SOLO SIMULACION -----------------------
import constants::SIM_CLK_PERIOD;

//-- Proceso de reloj
logic clk;
initial begin
    clk = 1;
    forever begin
        #(SIM_CLK_PERIOD / 2);
        clk = ~clk;
    end
end

//--------------------------------
//-- MICROCONTROLADOR
//--------------------------------
import constants::SYS_CLK_FREQ_MHZ;
import constants::UART_BAUD_RATE;
import constants::DEBOUNCER_SIZE_SIM;

//-- Leds
logic [15:0] leds;
logic [4:0] buttons;
logic [15:0] switches;
logic [7:0] segments;
logic [3:0] display_sel;


mcu #(
    .CLK_FREQUENCY_MHZ(SYS_CLK_FREQ_MHZ),
    .UART_BAUD_RATE(UART_BAUD_RATE),
    .DEBOUNCER_SIZE(DEBOUNCER_SIZE_SIM)
) u_mcu (
    //-- Main system clk
    .clk(clk),

    //-- Memory clock
    .clk_mem(~clk),

    //-- LEDs
    .leds(leds),

    //-- Buttons 
    .buttons_async(buttons),

    //-- Switches
    .switches_async(switches),

    //-- Display 7 segmentos
    .segments(segments),
    .segments_select(display_sel)
);

//-- Proceso de simulacion
initial begin
    //-- Generacion del volcado de ondas
    $dumpfile("sim.fst");
    $dumpvars;

    //-- Indicar comienzo simmulacion
    $display("Inicio: %t", $time);

    //-- Valor inicial de los pulsadores
    buttons = 5'h0;

    //-- Esperar a que finalice el reset
    repeat (32) @(posedge clk);

    @(posedge clk);

    buttons = 5'h0;

    repeat (7) @(posedge clk);

    buttons = 5'h0;

    repeat (7) @(posedge clk);

    buttons = 5'h1; //1

    repeat (7) @(posedge clk);

    buttons = 5'h0;

    repeat (7) @(posedge clk);

    buttons = 5'h1; //1

    repeat (7) @(posedge clk);

    buttons = 5'h0;

    repeat (7) @(posedge clk);

    //-- Ciclos de ejecucion
    repeat (10) @(posedge clk);


    //-- Indicar fin simulacion
    $display("Fin: %t", $time);
    $finish();
end

endmodule

