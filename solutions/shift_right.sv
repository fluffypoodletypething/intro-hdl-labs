`default_nettype none
`timescale 1ns/100ps
module shift_right(in,shamt,arithmetic,out);

parameter N=32;

input wire [N-1:0] in;
input wire arithmetic;
input wire [$clog2(N)-1:0] shamt;
output wire [N-1:0] out;

// <<<SOLUTION

logic extend;
always_comb extend = arithmetic & in[N-1];
mux32 #(.N(N)) SHIFT_MUX(
  .s(shamt[4:0]), .out(out),
  .in0(in),
  // print(",\n".join([f".in{i}( {{  {{ {{ 32'd{i} }} {{ extend }} }}, in[31:{i}]}})" for i in range(1, 32)]))
  // N.B. This is as gross as verilog gets. 
  .in1(  {  { { 32'd1 }  { extend } }, in[31:1]}),
  .in2(  {  { { 32'd2 }  { extend } }, in[31:2]}),
  .in3(  {  { { 32'd3 }  { extend } }, in[31:3]}),
  .in4(  {  { { 32'd4 }  { extend } }, in[31:4]}),
  .in5(  {  { { 32'd5 }  { extend } }, in[31:5]}),
  .in6(  {  { { 32'd6 }  { extend } }, in[31:6]}),
  .in7(  {  { { 32'd7 }  { extend } }, in[31:7]}),
  .in8(  {  { { 32'd8 }  { extend } }, in[31:8]}),
  .in9(  {  { { 32'd9 }  { extend } }, in[31:9]}),
  .in10( {  { { 32'd10 } { extend } }, in[31:10]}),
  .in11( {  { { 32'd11 } { extend } }, in[31:11]}),
  .in12( {  { { 32'd12 } { extend } }, in[31:12]}),
  .in13( {  { { 32'd13 } { extend } }, in[31:13]}),
  .in14( {  { { 32'd14 } { extend } }, in[31:14]}),
  .in15( {  { { 32'd15 } { extend } }, in[31:15]}),
  .in16( {  { { 32'd16 } { extend } }, in[31:16]}),
  .in17( {  { { 32'd17 } { extend } }, in[31:17]}),
  .in18( {  { { 32'd18 } { extend } }, in[31:18]}),
  .in19( {  { { 32'd19 } { extend } }, in[31:19]}),
  .in20( {  { { 32'd20 } { extend } }, in[31:20]}),
  .in21( {  { { 32'd21 } { extend } }, in[31:21]}),
  .in22( {  { { 32'd22 } { extend } }, in[31:22]}),
  .in23( {  { { 32'd23 } { extend } }, in[31:23]}),
  .in24( {  { { 32'd24 } { extend } }, in[31:24]}),
  .in25( {  { { 32'd25 } { extend } }, in[31:25]}),
  .in26( {  { { 32'd26 } { extend } }, in[31:26]}),
  .in27( {  { { 32'd27 } { extend } }, in[31:27]}),
  .in28( {  { { 32'd28 } { extend } }, in[31:28]}),
  .in29( {  { { 32'd29 } { extend } }, in[31:29]}),
  .in30( {  { { 32'd30 } { extend } }, in[31:30]}),
  .in31( {  { { 32'd31 } { extend } }, in[31:31]})
);

// SOLUTION>>>

endmodule
