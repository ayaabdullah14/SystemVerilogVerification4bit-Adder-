// Scoreboard – scoreboard.sv
class scoreboard;
  mailbox #(transaction) mon2scb;
  transaction tr;
  logic [4:0] exp_output;

  task run();
    forever begin
      // 1. Receive a transaction from the monitor.
      mon2scb.get(tr);

      // 2. Calculate the expected output.
      exp_output = tr.a + tr.b;

      // 3. Compare expected vs actual output.
      if (tr.c == exp_output)
        $display("PASS");
      else
        $display("FAIL — expected: %0d, actual: %0d", exp_output, tr.c);
    end
  endtask
endclass
