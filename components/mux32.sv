`default_nettype none

// python: print(", ".join([f"in{i}" for i in range(32)]))
module mux32(
  in0, in1, in2, in3, in4, in5, in6, in7, 
  in8, in9, in10, in11, in12, in13, in14, in15, 
  in16, in17, in18, in19, in20, in21, in22, in23, 
  in24, in25, in26, in27, in28, in29, in30, in31,
  s, out
);

parameter N=32;
// python: print(", ".join([f"in{i}" for i in range(32)]))
input wire [N-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
input wire [4:0] s;
output logic [N-1:0] out;

endmodule
