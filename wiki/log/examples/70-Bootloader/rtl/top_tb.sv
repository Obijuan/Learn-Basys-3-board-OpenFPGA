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
import constants::CLKS_PER_BIT;

//-- Señales
logic [15:0] leds;
logic [4:0] buttons;
logic [15:0] switches;
logic [7:0] segments;
logic [3:0] display_sel;
logic uart_tx;
logic uart_rx_async;


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
    .segments_select(display_sel),

    //-- SERIAL PORT
    .uart_tx(uart_tx),
    .uart_rx_async(uart_rx_async)
);


localparam RED = "\033[31m";
localparam GREEN = "\033[32m";
localparam YELLOW = "\033[33m";
localparam BLUE = "\033[34m";
localparam MAGENTA = "\033[35m";
localparam CYAN = "\033[36m";
localparam ORANGE = "\033[0;33m";
localparam RESET = "\033[0m";

//-- Contador de errores
integer error_count = 0;


//-- Proceso de simulacion
initial begin
        $dumpfile("sim.fst");
        $dumpvars;

        // Run for 10000 cycles max
        repeat (100000) @(negedge clk);

        // Stop simulation
        $display("%s", ORANGE);
        $display("Simulation timeout!");
        $display("%s", RESET);
        $finish();
    end

    // Respond to test interface
    always @(posedge clk) begin
        if (u_mcu.wb_test.test_stb) begin
            case (u_mcu.wb_test.test_reg)
                0: $display("(%6d ps) Test pass!", $time());
                1: begin
                    $display("(%6d ps) Test fail!", $time());
                    error_count <= error_count + 1;
                end
                2: begin
                    $finish();
                    print_test_done();
                end
            endcase
        end
    end

    // --------------------------------------------------------------------------------------------
    // print helper functions
    function void print_test_done();
        if (error_count == 0) begin
            $display("\033[0;33m"); // color_orange
            $display("Inital test failed! (# Errors: %1d)", error_count);
        end
        else if (error_count > 1) begin
            $display("\033[0;31m"); // color_red
            $display("Some test(s) failed! (# Errors: %1d)", error_count);
        end
        else begin
            $display("\033[0;32m"); // color green
            $display("All tests passed! (# Errors: %1d = initial test)", error_count);
        end
        $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        $display("!!!!!!!!!!!!!!!!!!!! TEST DONE !!!!!!!!!!!!!!!!!!!!");
        $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        $display("\033[0m"); // color off
    endfunction
endmodule

