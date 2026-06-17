//-------------------------------------------------------------------
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none `timescale 100 ns / 10 ns

module ledon_tb ();

  //-- Simulation time: 1us (10 * 100ns)
  parameter DURATION = 10;

  //-- Leds port
  wire [1:0] leds;

  //-- Isolate leds
  wire led0 = leds[0];
  wire led1 = leds[1];

  //-- Instantiate the unit to test
  ledon2 UUT (
      .leds(leds)
  );




  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, ledon_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
