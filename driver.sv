class driver;
  virtual my_interface vif;
  mailbox #(transaction) gen2driv;
  transaction tr;
  int counter = 0;

  task run();
    forever begin
      // 1. Retrieve a transaction from the gen2driv mailbox.
      gen2driv.get(tr);
      // 2. Increment the transaction counter.
      counter++;

      // 3. Synchronize with the clock's rising edge.
      @(posedge vif.clk);

      // 4. If reset is active, drive all outputs to zero.
      if (vif.reset == 1) begin
        vif.a     = 0;
        vif.b     = 0;
        vif.valid = 0;
      end
      // 5. Otherwise, assign values to interface signals and assert valid.
      else begin
        vif.a     = tr.a;
        vif.b     = tr.b;
        vif.valid = 1;
      end

      // 6. Handle transaction delay before sending the next transaction.
      repeat(tr.delay) @(posedge vif.clk);

      // 7. Display the transaction details for debugging.
      $display("[DRIVER] count=%0d a=%0d b=%0d delay=%0d",
                counter, tr.a, tr.b, tr.delay);
    end
  endtask
endclass
