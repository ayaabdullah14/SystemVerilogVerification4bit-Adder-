// Environment – environment.sv
class environment;
  virtual my_interface vif;
  agent      ag;
  scoreboard scb;
  mailbox #(transaction) mon2scb;

  function void build();
    mon2scb = new(1);
    ag      = new();
    scb     = new();
    ag.build();
  endfunction

  function void connect();
    ag.vif      = vif;
    ag.mon2scb  = mon2scb;
    scb.mon2scb = mon2scb;
    ag.connect();
  endfunction

  virtual task run();
    fork
      ag.run();
      scb.run();
    join
  endtask
endclass
