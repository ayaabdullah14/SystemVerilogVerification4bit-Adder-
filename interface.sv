// Interface – interface.sv
interface my_interface(input logic clk);
  logic        reset;
  logic [3:0]  a;
  logic [3:0]  b;
  logic        valid;
  logic [4:0]  c;
endinterface
