/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/
`default_nettype none
`timescale 1ns/1ps
module adder_1(a, b, c_in, sum, c_out);

input wire a, b, c_in;
output logic sum, c_out;

// <<SOLUTION
// Figure 5.3 from the text:
always_comb begin : adder_gates
  c_out = a&b | a&c_in | b&c_in;
  sum = c_in ^ a ^ b;
end
// SOLUTION>>>

endmodule