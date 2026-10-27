`default_nettype none

// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and
// hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

// An example of defining a net for FSMs that can be very helpful.
typedef enum logic {COUNTING_UP, COUNTING_DOWN} state_t;
state_t state;

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