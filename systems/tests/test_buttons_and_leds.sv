`default_nettype none
`timescale 1ns/1ps

module test_buttons_and_leds;

   parameter CLK_HZ = 25_000_000;
   localparam CLK_PERIOD_NS = 1_000_000_000.0/CLK_HZ;

   // UUT IO
   logic       clk;
   logic [6:0] buttons;
   wire  [7:0] leds;

   buttons_and_leds DUT(.clk(clk), 
                        .buttons(buttons), 
                        .leds(leds)
                        );

   int bounces, delay;
   task bounce_button();
      bounces = ($urandom % 20) + 10;
      $display("Starting a bounce sequence %d", bounces);
      for(int i = 0; i < bounces; i = i + 1) begin
         delay = ($urandom % 15) + 1;
         $display("Bouncing with delay %d", delay);
         #(delay) buttons[1] = $urandom;
      end
   endtask

   initial begin
      $dumpfile("buttons_and_leds.fst");
      $dumpvars;
      clk = 0;

      // This will reset it
      buttons = 7'b0000000;
      repeat(250) @(negedge clk);

      // This will turn on the LEDs
      buttons = 7'b1111111;
      repeat(250) @(negedge clk);
      
      // Turn off
      buttons = 7'b0000001;
      repeat(250) @(negedge clk);
      
      for(int i = 0; i < 5; i = i + 1) begin
         $display("On test number %2d", i);
         bounce_button();
         buttons[1] = 1;

         repeat (250) @(posedge clk);

         bounce_button();
         buttons[1] = 0;

         repeat (250) @(posedge clk);
      end

      $finish;
   end

   initial begin
      repeat (1_000_000) @(posedge clk);
      $display("Test timed out!");
      $finish;
   end

   always #(CLK_PERIOD_NS/2.0) clk = ~clk;

endmodule

