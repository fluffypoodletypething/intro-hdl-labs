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
   end

   logic button_pressed;
   // This signal is the or of all buttons
   always_comb button_pressed = |buttons[6:1]; // Exclude buttons[0] as that resets

   // Sequential logic example: an edge detector, on edge, toggle_led_state flips
   logic toggle_led_state;
   logic prev_button_pressed; // Value of button pressed on last clock
   logic button_pressed_posedge; // Combinational signal

   // Edge detector: look at the last value of a signal and the current value,
   // if last is low and current is high we have a posedge

   // TODO: Think about how you can modify this to debounce the input more effectively.
   always_comb button_pressed_posedge = ~prev_button_pressed & button_pressed;

   always_ff @(posedge clk) begin
      if(rst) begin
         toggle_led_state <= 0;
         prev_button_pressed <= 0;
      end else begin
         // Store previous value
         prev_button_pressed <= button_pressed;

         // Toggle if an edge
         if(button_pressed_posedge) begin
            toggle_led_state <= ~toggle_led_state;
         end
      end
   end // always_ff @ (posedge clk)

   // Lastly, drive leds 6 and 7
   always_comb begin
      leds[6] = toggle_led_state;
      leds[7] = ~toggle_led_state;
   end
endmodule
