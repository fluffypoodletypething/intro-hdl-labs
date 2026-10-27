`default_nettype none
`timescale 1ns/1ps

module comparator_eq(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

// Using only *structural* combinational logic, make a module that computes if a == b. 

// Copy any other modules you use into the HDL folder and update the Makefile accordingly.

// SOLUTION START
// The solution is to and together the bit-wise nxor of the inputs:
always_comb out = &(a ~^ b);
// SOLUTION END

endmodule


