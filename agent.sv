class agent;
  virtual my_interface vif;
  mailbox #(transaction) gen2driv;
  mailbox #(transaction) mon2scb;
  generator gen;
  driver    drv;
  monitor   mon;

  function void build();
    gen2driv = new(1);
    mon2scb  = new();
    gen = new();
    drv = new();
    mon = new();
  endfunction

  function void connect();
    gen.gen2driv = gen2driv;
    drv.gen2driv = gen2driv;
    drv.vif      = vif;
    mon.vif      = vif;
    mon.mon2scb  = mon2scb;
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
    join_any
  endtask
endclass
