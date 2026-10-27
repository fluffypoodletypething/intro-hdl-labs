module edge_detector(clk, rst, in, positive_edge, negative_edge);

input wire clk, rst, in;
output logic positive_edge, negative_edge;
parameter SYNC_DEPTH = 0; // Use this if you need to synchronize the input.
parameter ACTIVE_LOW = 1'b0; // Set this to 1'b1 if the input is active low and will be high voltage at reset to avoid spurious edges.

// TODO(avinash) include debounce element?

logic [SYNC_DEPTH:0] in_buffer;
always @(posedge clk) begin
  if(rst) begin
    in_buffer <= ACTIVE_LOW ? -1 : 0;
  end else begin
    in_buffer[0] <= in;
    if(SYNC_DEPTH > 0) begin
      in_buffer[SYNC_DEPTH:1] <= in_buffer[SYNC_DEPTH-1:0];
    end
  end
end

always_comb begin : mealy_output_logic
  if(SYNC_DEPTH > 0) begin
    positive_edge = in_buffer[SYNC_DEPTH-1] & ~in_buffer[SYNC_DEPTH];
    negative_edge = ~in_buffer[SYNC_DEPTH-1] & in_buffer[SYNC_DEPTH];
  end else begin
    positive_edge = in & ~in_buffer[0];
    negative_edge = ~in & in_buffer[0];
  end
end

endmodule // edge_detector
