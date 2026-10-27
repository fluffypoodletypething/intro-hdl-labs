`default_nettype none

module comparator_lt(a, b, out);

parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

// Using only *structural* combinational logic (or instantiated modules that 
// only consist of structural combination logic), make a module that outputs 
// high if a < b.
// If you use other modules, make sure to update the sources in the Makefile 
// appropriately!




endmodule
