`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);

// Based on Figure 5.17 in Harris and Harris (which helpfully includes the overflow and carry out logic as well).
parameter N = 32;

input wire signed [N-1:0] a, b;
input alu_control_t control;

output logic signed [N-1:0] result; // Result of the selected operation.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Excel outputs (leave as zero till everything else works).
output logic overflow; // Is high if the result of an ADD, SUB, SLT, or SLTU wraps around the 32 bit boundary. 

// <<<SOLUTION

// Intermediate result wires.
logic [N-1:0] a_and_b, a_or_b, a_xor_b, a_sll_b, a_sr_b, b_inverted, less_than;

// Basic Boolean Operations._
always_comb begin : basic_gates
  a_and_b = a & b;
  a_or_b = a | b;
  a_xor_b = a ^ b;
  b_inverted = ~b;
end


// Single ALU that can do ADD, SUB, SLT, and SLTU.
logic [N-1:0] alu_b;
logic alu_c_in;
always_comb begin: alu_muxing
  alu_b = control[2] ? b_inverted : b;
  alu_c_in = control[2];
end

wire alu_c_out;
wire [N-1:0] alu_result;
adder_n #(.N(N)) ADDER(
  .a(a), .b(alu_b), .c_in(alu_c_in), .c_out(alu_c_out), .sum(alu_result)
);

// Comparators and Flags. Note that this is all summarized neatly in section 5.2.4. of the textbook, reproduced here with the correct control signals for a risc-v implementation.
/*
(oVerflow) is asserted when all three of the following conditions are true:
(1) the ALU is performing addition or subtraction (control[3] == 1'b1),
(2) A and Sum have opposite signs, as detected by the XOR gate, and
(3) overflow is possible. That is, as detected by the XNOR gate, either
A and B have the same sign and the adder is performing addition
(control[2] = 0) or A and B have opposite signs and the adder is per-
forming subtraction (control[2] == 1'b1). The 3-input AND gate detects
when all three conditions are true and asserts V.
*/
comparator_eq #(.N(N)) EQUAL (.a(a), .b(b), .out(equal));
always_comb zero = ~(|result); // Slightly simpler than using another comparator_eq.
logic a_slt_b, a_sltu_b; // True if a < b based on the SLT/SLTU control bit (control[1]);
logic different_signs, same_signs, overflow_possible;
always_comb begin
  overflow_possible = ~^{a[N-1], b[N-1], control[2]};
  overflow = control[3] & // Overflow possible only on ADD, SUB, SLT, and SLTU
      (a[N-1] ^ alu_result[N-1]) & // Check for differing signs between a and result.
      overflow_possible;
  a_slt_b = alu_result[N-1] ^ overflow;
  // a_slt_b = alu_result[N-1] & ~inputs_had_different_signs; // & ~sub_overflow;
  a_sltu_b = ~alu_c_out;
  less_than[N-1:1] = 0;
  less_than[0] = control[1] ? a_sltu_b : a_slt_b;
// So just making and N+1 adder results in the similar gate usage if you need to track overflows, though the logic is slightly different.
end




// Shifters:
wire [N-1:0] unzeroed_shift, zeroed_shift;
logic shamt_too_big;
always_comb shamt_too_big = |b[N-1:$clog2(N)];


sll #(.N(N)) SHIFT_LEFT (.in(a), .shamt(b[$clog2(N)-1:0]), .out(a_sll_b));
shift_right #(.N(N)) SHIFT_RIGHT(.in(a), .shamt(b[$clog2(N)-1:0]), .arithmetic(control[0]), .out(a_sr_b));

mux2 #(.N(N)) SHIFTER_MUX(.in0(a_sll_b), .in1(a_sr_b), .s(control[1]), .out(unzeroed_shift));
mux2 #(.N(N)) ZERO_OUT_SHIFTER_MUX(.in0(unzeroed_shift), .in1(0), .out(zeroed_shift), .s(shamt_too_big));

// Result Muxing. You can use a 16:1 mux, or judicious 2:1 Muxes. Here's the more minimal approach - note that you need 5 2:1 muxes in a cascade. Uses one third the 15 2:12 muxes that a 16:1 binary tree implements!
wire [N-1:0] a_and_xor_b, boolean_result, boolean_or_shift_result, adder_or_comparator_result, a_lt_b, a_ltu_b;
mux2 #(.N(N)) BOOLEAN_MUX0(
  .s(control[1]), .in0(a_and_b), .in1(a_xor_b), .out(a_and_xor_b)
);
mux2 #(.N(N)) BOOLEAN_MUX1(
  .s(control[0]), .in0(a_or_b), .in1(a_and_xor_b), .out(boolean_result)
);
mux2 #(.N(N)) BOOLEAN_OR_SHIFT_MUX(
  .s(control[2]), .in0(boolean_result), .in1(zeroed_shift), .out(boolean_or_shift_result)
);
mux2 #(.N(N)) ADDER_OR_LT_MUX(
  .s(control[0]), .in0(alu_result), .in1(less_than),
  .out(adder_or_comparator_result)
);
mux2 #(.N(N)) RESULT_MUX(
  .s(control[3]), .in0(boolean_or_shift_result), .in1(adder_or_comparator_result), .out(result)
);

/*
Of course you can always do something like this as well. 

mux16 #(.N(N)) RESULT_MUX(
  .in0(a_and_b),
  .in1(0),
  .in2(a_or_b),
  .in3(a_xor_b),
  .in4(0),
  .in5(a_sll_b),
  .in6(a_srl_b),
  .in7(a_sra_b),
  .in8(alu_result),
  .in9(0),
  .in10(0),
  .in11(0),
  .in12(0),
  .in13(a_slt_b),
  .in14(0),
  .in15(a_sltu_b),
  .s(control),
  .out(result)
);
*/ 

// SOLUTION>>>

endmodule
