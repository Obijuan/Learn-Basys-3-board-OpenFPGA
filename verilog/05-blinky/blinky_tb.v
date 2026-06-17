//-------------------------------------------------------------------
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none `timescale 100 ns / 10 ns

module blinky_tb ();

  //-- Simulation time: 1us (10 * 100ns)
  parameter DURATION = 30;

  //-- System clock
  reg clk;

  //-- Leds port
  wire [15:0] leds;

  //-- Instantiate the unit to test
  main UUT (
      .clk(clk),
      .leds(leds)
  );

//-- Led Real que parpadea
//-- Como la simulacion es muy corta, siempre se vera a 0
wire led0 = leds[0];

//-- Led virtual para ver el parpadeo
//-- Se usa el bit 1 del contador interno
wire led_sim = UUT.counter[1];


// System clock
  initial begin
      clk = 1;
      forever begin
          #1;
          clk = ~clk;
      end
  end


  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, blinky_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
