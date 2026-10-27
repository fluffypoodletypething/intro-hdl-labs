`default_nettype none
`timescale 1ns/1ps

module mux2(in0, in1, s, out);

parameter N=32;
input wire [N-1:0] in0, in1;
input wire s;
output logic [N-1:0] out;

// A CMOS sum of products type of implementation - note that you have to 
//  replicate the bits of s and ~s to match the size of the parameterized
//  input.
// always_comb out = {N{~s}} & in0 | {N{s}} & in1;

// The more conventional way of implementing a 2:1 mux:
always_comb out = s ? in1 : in0;

endmodule
