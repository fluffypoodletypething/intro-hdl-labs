`default_nettype none

// python: print(", ".join([f"in{i}" for i in range(16)]))
module mux16(
  in0, in1, in2, in3, in4, in5, in6, in7, 
  in8, in9, in10, in11, in12, in13, in14, in15, 
  s, out
);

parameter N=32;
input wire [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
input wire [3:0] s;
output logic [N-1:0] out;

endmodule
