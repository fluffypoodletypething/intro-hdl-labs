`default_nettype none

module srl(in, shamt, out);

parameter N=32;

input wire [N-1:0] in;
input wire [$clog2(N)-1:0] shamt;
output wire [N-1:0] out;

// SOLUTION<<<

mux32 #(.N(N)) SHIFT_MUX(
  .s(shamt),
  .out(out),
  .in0(in),
  // print(",\n".join([f".in{i}({{{i}'b0, in[31:{i}]}})" for i in range(1, 32)]))
  .in1( {1'b0,  in[31:1]}),
  .in2( {2'b0,  in[31:2]}),
  .in3( {3'b0,  in[31:3]}),
  .in4( {4'b0,  in[31:4]}),
  .in5( {5'b0,  in[31:5]}),
  .in6( {6'b0,  in[31:6]}),
  .in7( {7'b0,  in[31:7]}),
  .in8( {8'b0,  in[31:8]}),
  .in9( {9'b0,  in[31:9]}),
  .in10({10'b0, in[31:10]}),
  .in11({11'b0, in[31:11]}),
  .in12({12'b0, in[31:12]}),
  .in13({13'b0, in[31:13]}),
  .in14({14'b0, in[31:14]}),
  .in15({15'b0, in[31:15]}),
  .in16({16'b0, in[31:16]}),
  .in17({17'b0, in[31:17]}),
  .in18({18'b0, in[31:18]}),
  .in19({19'b0, in[31:19]}),
  .in20({20'b0, in[31:20]}),
  .in21({21'b0, in[31:21]}),
  .in22({22'b0, in[31:22]}),
  .in23({23'b0, in[31:23]}),
  .in24({24'b0, in[31:24]}),
  .in25({25'b0, in[31:25]}),
  .in26({26'b0, in[31:26]}),
  .in27({27'b0, in[31:27]}),
  .in28({28'b0, in[31:28]}),
  .in29({29'b0, in[31:29]}),
  .in30({30'b0, in[31:30]}),
  .in31({31'b0, in[31:31]})
);

// SOLUTION>>>

endmodule
