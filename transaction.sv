class transaction;
  rand logic [3:0] a;
  rand logic [3:0] b;
  logic [4:0] c;
  rand bit [3:0] delay;

  constraint delay_c { delay inside {[1:5]}; }

  function void display();
    $display("a=%0d b=%0d c=%0d delay=%0d", a, b, c, delay);
  endfunction
endclass
