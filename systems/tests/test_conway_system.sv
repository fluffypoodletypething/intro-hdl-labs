`timescale 1ns / 1ps
`default_nettype none

// `define SIMULATION

module test_conway_system;

parameter N = 5;
parameter M = N + 2;

// Run components faster in simulation.
parameter game_period = 10;
parameter display_period = 1; 
localparam cycles_to_run = game_period*11;

// Inputs
logic clk;
logic [1:0] buttons;
wire [1:0] leds;
wire [2:0] rgb;
wire [N-1:0] cols;
wire [N-1:0] rows;

conway_system #(
  .N(N), .M(M), .game_period(game_period), .display_period(display_period)) 
UUT(
  .clk(clk), .buttons(buttons), 
  .leds(leds), .rgb(rgb), .cols(cols), .rows(rows)
);

led_array_model #(.N(N)) LED_ARRAY_MODEL(
  .rows(rows), .cols(cols)
);

int cycles = game_period*10; // Number of cycles to run.

// Run our main clock.
always #5 clk = ~clk;

int offset;
logic [N-1:0] row_to_print = 0;
initial begin
  // Collect waveforms
  $dumpfile("conway_system.fst");
  $dumpvars(0, UUT);
  // Initialize module inputs.
  clk = 0;
  buttons = 2'b11; //using button[0] as reset.
  // Assert reset for long enough.
  repeat(2) @(posedge clk);
  buttons = 2'b00;

  // Let the simulation run!
  for (int i = 0; i < cycles_to_run; i = i + 1) begin
    @(posedge clk);
    if(UUT.game_ena) begin
      $display("~~~~~~~~~~ < cycle: %02d > cells: ~~~~~~~~~~", i);
      for (int j = N-1; j >= 0; j = j - 1) begin
        row_to_print = UUT.cells_q >> j*N;
        $display("-%b-", row_to_print);
      end
    end
    /*
    if(UUT.display_counter[UUT.display_divider]) begin
      $display("rows = %b, cols = %b, leds = ", rows, cols);
      LED_ARRAY_MODEL.print_status();
    end
    */
  end
  
  $finish;      
end

endmodule
