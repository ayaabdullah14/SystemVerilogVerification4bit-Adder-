class generator;
  mailbox #(transaction) gen2driv;
  transaction tr;

  virtual task run();
    repeat (20) begin
      tr = new();
      if (!tr.randomize()) begin
        $error("Randomization failed!");
      end
      gen2driv.put(tr);
    end
  endtask
endclass
