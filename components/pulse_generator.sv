`default_nettype none
// Outputs a pulse on out with a period of "ticks".
// i.e. out should go high for one cycle every "ticks" clocks.

module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
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
