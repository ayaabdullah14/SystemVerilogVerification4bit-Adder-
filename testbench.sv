// Top-level Testbench – testbench.sv
`include "adder.sv"
`include "interface.sv"
`include "wrapper.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "monitor.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

module top_testbench;
  logic clk;

  // Clock generation: toggle every 1 time unit
  initial clk = 0;
  always #1 clk <= ~clk;

  // Interface and DUT wrapper
  my_interface inf(clk);
  wrapper      wrap(inf);

  // Run the test
  initial begin
    test tst;
    tst     = new();
    tst.vif = inf;
    tst.build();
    tst.connect();
    tst.run();
  end

  // Simulation timeout
  initial begin
    #300;
    $finish();
  end

  // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
