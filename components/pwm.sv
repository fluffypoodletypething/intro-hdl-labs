`default_nettype none

// Generates a Pulse Width Modulated signal.
// If ena is low the output should be low.
// If duty is zero the output should be zero.
// If duty is the max value (2^N-1) the output does not need ot be fully high 
//   (it's okay if it goes low for one cycle).
// Excel goal: find a way so that the output is steady high if duty = 2^N -1.

module pwm(clk, rst, ena, duty, out);

parameter N = 8;

input wire clk, rst;
input wire ena; // Enables the output.
input wire [N-1:0] duty; // The "duty cycle" input.
output logic out;

// Only use structural (always_comb or always_ff @(posedge clk) blocks) or
// instantiations of other structural modules.
// Do NOT use advanced operators like +, -, >, <, ==, etc...

// Building blocks that should be helpful: comparator_*, adder_n, register.

// If you use other modules, make sure to update the sources in the Makefile 
// appropriately!

// For this module (and most sequential ones) it is okay to put the basic
// combinational operators (&, |, ^, ~, ?) on the right side of always_ff 
// <= operators. For example q <= ena & a; is perfectly acceptable.

endmodule
