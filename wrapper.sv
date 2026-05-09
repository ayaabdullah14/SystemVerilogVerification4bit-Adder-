// Wrapper – wrapper.sv
module wrapper(my_interface vif);
  adder dut (
    .clk   (vif.clk),
    .reset (vif.reset),
    .a     (vif.a),
    .b     (vif.b),
    .valid (vif.valid),
    .c     (vif.c)
  );
endmodule
