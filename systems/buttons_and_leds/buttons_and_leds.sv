`default_nettype none


module buttons_and_leds(/*AUTOARG*/
   // Outputs
   leds,
   // Inputs
   clk, buttons
   );
   input wire clk;
   input  wire [6:0] buttons; // buttons[0]: power; buttons[1..2]: fire; buttons[3..6]: "dpad"
   output logic [7:0] leds;

   // Power button is reset signal
   logic rst;
   always_comb rst = ~buttons[0]; // This has a pull up so it is normally high, thus we invert

   always_comb begin
      // Assign each button an LED
      leds[5:0] = buttons[6:1];
      // leds[7] is always off for now; try to make it blink for step 2a
      leds[7] = 1'b1;
   end

   logic button_pressed;
   // This signal is the or of buttons [6:1], hence the prefix |
   always_comb button_pressed = |buttons[6:1]; // Exclude buttons[0] as that resets

   // Sequential logic example: an edge detector, on edge, toggle_led_state flips
   logic flippy_led_state;

   // TODO: Step 2b Think about how you can modify this to debounce the input and only
   // change on an edge. Use your modules

   always_ff @(posedge clk) begin
      if(rst) begin
         flippy_led_state <= 0;
      end else begin
         // Toggle if an edge
         if(button_pressed) begin
            flippy_led_state <= ~flippy_led_state;
         end
      end
   end // always_ff @ (posedge clk)

   // Lastly, drive leds 6 and 7
   always_comb begin
      leds[6] = flippy_led_state;
   end
endmodule
