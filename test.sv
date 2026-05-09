// Test – test.sv
class test;
  environment      env;
  virtual my_interface vif;

  function void build();
    env = new();
    env.build();
  endfunction

  function void connect();
    env.vif = vif;
    env.connect();
  endfunction

  task reset();
    vif.reset = 1;
    #10;
    vif.reset = 0;
  endtask

  task run();
    reset();
    env.run();
  endtask

  virtual task execute();
    build();
    connect();
    run();
  endtask
endclass
