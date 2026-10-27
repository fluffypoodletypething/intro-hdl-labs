`default_nettype none
`timescale 1ns/100ps

module sll(in, shamt, out);

parameter N=32;

input wire [N-1:0] in;
input wire [$clog2(N)-1:0] shamt;
output wire [N-1:0] out;

// <<<SOLUTION

mux32 #(.N(N)) SHIFT_MUX(
  .s(shamt), .out(out),
  .in0(in),
  // print(",\n".join([f".in{i}({{in[{31-i}:0], {i}'b0}})" for i in range(1, 32)]))
  .in1( {in[30:0], 1'b0}),
  .in2( {in[29:0], 2'b0}),
  .in3( {in[28:0], 3'b0}),
  .in4( {in[27:0], 4'b0}),
  .in5( {in[26:0], 5'b0}),
  .in6( {in[25:0], 6'b0}),
  .in7( {in[24:0], 7'b0}),
  .in8( {in[23:0], 8'b0}),
  .in9( {in[22:0], 9'b0}),
  .in10({in[21:0], 10'b0}),
  .in11({in[20:0], 11'b0}),
  .in12({in[19:0], 12'b0}),
  .in13({in[18:0], 13'b0}),
  .in14({in[17:0], 14'b0}),
  .in15({in[16:0], 15'b0}),
  .in16({in[15:0], 16'b0}),
  .in17({in[14:0], 17'b0}),
  .in18({in[13:0], 18'b0}),
  .in19({in[12:0], 19'b0}),
  .in20({in[11:0], 20'b0}),
  .in21({in[10:0], 21'b0}),
  .in22({in[9:0],  22'b0}),
  .in23({in[8:0],  23'b0}),
  .in24({in[7:0],  24'b0}),
  .in25({in[6:0],  25'b0}),
  .in26({in[5:0],  26'b0}),
  .in27({in[4:0],  27'b0}),
  .in28({in[3:0],  28'b0}),
  .in29({in[2:0],  29'b0}),
  .in30({in[1:0],  30'b0}),
  .in31({in[0:0],  31'b0})
);

// SOLUTION>>>

endmodule
