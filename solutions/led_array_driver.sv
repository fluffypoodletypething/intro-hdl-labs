`default_nettype none
`timescale 1ns/1ps

// This module 


module led_array_driver(ena, x, cells, rows, cols);
// Module I/O and parameters
parameter N=8; // Size of Conway Cell Grid.
parameter ROWS=N;
parameter COLS=N;

// I/O declarations
input wire ena;
input wire [$clog2(N)-1:0] x;
input wire [N*N-1:0] cells;
output logic [N-1:0] rows;
output logic [N-1:0] cols;


// You can check parameters with the $error macro within initial blocks.
initial begin
  if ((N <= 0) || (N > 8)) begin
    $error("N must be within 0 and 8.");
  end
  if (ROWS != COLS) begin
    $error("Non square led arrays are not supported. (%dx%d)", ROWS, COLS);
  end
  if (ROWS < N) begin
    $error("ROWS/COLS must be >= than the size of the Conway Grid.");
  end
end

wire [N-1:0] x_decoded;
decoder_3_to_8 COL_DECODER(
  .ena(ena),
  .in(x),
  .out(x_decoded)
);

// <<<SOLUTION
always_comb cols = x_decoded;  

`define GENERATE_ROW_COL_DECODERS
`ifdef GENERATE_ROW_COL_DECODERS  
generate
genvar i;
for(i = 0; i < N; i = i + 1) begin : row_decoders
  always_comb begin
    rows[i] = ~|(cells[(i+1)*N-1:i*N] & x_decoded);
  end
end
endgenerate

`else // else GENERATE_ROW_COL_DECODERS
initial if (! ((N==5) || (N==8))) 
  $error("Manual logic only written for 5x5 and 8x8 drivers.");
always_comb begin
/* python snippet to generate arbitrary grid sizes 
N = 8
print("\n".join([f"rows[{i}] =  ~|(x_decoded & cells[{N*(i+1)-1:2d}:{N*i}]);" for i in range(N)]))
*/
    if( N == 5 ) begin // 5x5 logic
      rows[0] = ~|(cells[ 4: 0] & x_decoded);
      rows[1] = ~|(cells[ 9: 5] & x_decoded);
      rows[2] = ~|(cells[14:10] & x_decoded);
      rows[3] = ~|(cells[19:15] & x_decoded);
      rows[4] = ~|(cells[24:20] & x_decoded);
    end else begin
      rows = -1;
    end
    if (N == 8 ) begin // 8x8 logic
      rows[0] =  ~|(x_decoded & cells[ 7:0]);
      rows[1] =  ~|(x_decoded & cells[15:8]);
      rows[2] =  ~|(x_decoded & cells[23:16]);
      rows[3] =  ~|(x_decoded & cells[31:24]);
      rows[4] =  ~|(x_decoded & cells[39:32]);
      rows[5] =  ~|(x_decoded & cells[47:40]);
      rows[6] =  ~|(x_decoded & cells[55:48]);
      rows[7] =  ~|(x_decoded & cells[63:56]);
    end
end

`endif // GENERATE_ROW_COL_DECODERS
  
  
// SOLUTION>>>
endmodule
