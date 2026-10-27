`default_nettype none

module buttons_and_leds(clk, buttons, rgb, leds);

parameter ON_COLOR=3'b001;
parameter OFF_COLOR=3'b100;

input wire clk;
input wire [1:0] buttons;
output reg [2:0] rgb;
output reg [1:0] leds;

// Create a reset signal from one of the buttons.
logic rst; always_comb rst = buttons[0];

// Example of using combinational logic to drive outputs.
// Question: Why are we using inverting gates here? Hint: check the schematic!
always_comb begin : basic_gates
  leds[0] = ~(buttons[0] & buttons[1]);
  leds[1] = ~(buttons[0] | buttons[1]);
end

logic button_pressed;

// Example of some simple "sequential logic" to create a tap on/tap off LED.
// Note: there's an issue with this! It shouldn't work very reliably.
always_comb button_pressed = buttons[1];


// Using always_ff to create a flip flop with synchronous reset.
logic q; // State that will drive our LED.
always_ff @(posedge clk) begin
  if(rst) begin
    q <= 0;
  end else begin
    // If button[1] is "pressed" toggle q.
    if(button_pressed) begin
      q <= ~q; // This sneaks some combinational logic into our always_ff statement. 
    end
  end
end

always_comb begin : led_driving
  rgb = q ? ON_COLOR : OFF_COLOR;
end


endmodule
