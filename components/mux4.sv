`default_nettype none

module mux4(in0, in1, in2, in3, s, out);

parameter N=32;
input wire [N-1:0] in0, in1, in2, in3;
input wire [1:0] s;
output logic [N-1:0] out;

endmodule
