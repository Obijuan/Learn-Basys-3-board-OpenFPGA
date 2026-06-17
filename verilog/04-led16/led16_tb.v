//-------------------------------------------------------------------
//-- Testbench
//-------------------------------------------------------------------
//-- Juan Gonzalez (Obijuan)
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none `timescale 100 ns / 10 ns

module led8_tb ();

  //-- Simulation time: 1us (10 * 100ns)
  parameter DURATION = 10;

  //-- Leds port
  wire [15:0] leds;

  //-- Instantiate the unit to test
  main UUT (
      .leds(leds)
  );

  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, led8_tb);

    #(DURATION) $display("End of simulation");
    $finish;
  end

endmodule
