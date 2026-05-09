class monitor;
  virtual my_interface vif;
  mailbox #(transaction) mon2scb;
  transaction tr;

  task run();
    forever begin
      // 1. Synchronize with the clock's rising edge.
      @(posedge vif.clk);

      // 2. Wait for the valid signal to become active before capturing data.
      if (vif.valid) begin
        // 3. Create a new transaction and assign interface signal values.
        tr = new();
        tr.a = vif.a;
        tr.b = vif.b;
        tr.c = vif.c;

        // 4. Send the captured transaction to the scoreboard.
        mon2scb.put(tr);
        $display("[MONITOR] a=%0d b=%0d c=%0d", tr.a, tr.b, tr.c);
      end
    end
  endtask
endclass
