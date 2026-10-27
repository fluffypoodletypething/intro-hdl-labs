// Outputs a pulse generator with a period of "ticks".
// outt should go high for one cycle ever "ticks" clocks.

`timescale 1ns/1ps
`default_nettype none

module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

// SOLUTION START

logic [N-1:0] counter;
logic count_done;
always_comb begin : comparator_logic
  count_done = (counter >= ticks);
end

always_ff @(posedge clk) begin : counter_logic
  if(rst) begin
    counter <= 0;
  end
  else if (ena) begin
    if (counter_comparator) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end
end

always_comb begin : output_logic
  out = counter_comparator & ena;
end 

endmodule
