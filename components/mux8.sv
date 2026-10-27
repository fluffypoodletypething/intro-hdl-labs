`default_nettype none

module mux8(in0, in1, in2, in3, in4, in5, in6, in7, s, out);

parameter N=32;
input wire [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
input wire [2:0] s;
output logic [N-1:0] out;

endmodule
