`timescale 1ns/1ps
`default_nettype none

module decoder_4_to_16(ena, in, out);

input wire ena;
input wire [3:0] in;
output logic [15:0] out;

endmodule