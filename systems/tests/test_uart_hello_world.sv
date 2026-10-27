`default_nettype none
`timescale 1ns/1ps

// Auto-generated on 2023-08-05 14:33:53

module test_uart_hello_world;


parameter CLK_HZ = 12_000_000;
localparam CLK_PERIOD_NS = 1_000_000_000.0/CLK_HZ;
parameter BAUDRATE = 115_200;
localparam BAUD_PERIOD_NS = 1_000_000_000.0/BAUDRATE;
parameter ROM_L = 13;

// UUT IO
logic  clk;
logic [1:0] buttons;
wire rst; assign rst = buttons[0];
wire [1:0] leds;
wire [2:0] rgb;
wire  uart_rx, uart_tx;


uart_hello_world #(
  .CLK_HZ(CLK_HZ),
  .BAUDRATE(BAUDRATE),
  .ROM_L(ROM_L)
) UUT (
  .clk(clk),
  .buttons(buttons),
  .leds(leds),
  .rgb(rgb),
  .uart_rx(uart_rx),
  .uart_tx(uart_tx)
);

uart_tester #(
) UART_TESTER (
  .clk(clk), .rst(rst), .uart_tx(uart_tx), .uart_rx(uart_rx)
);

initial begin
  $dumpfile("uart_hello_world.fst");
  $dumpvars;
  clk = 0;
  buttons = 2'b11;

  repeat(2) @(negedge clk);
  buttons = 0;

  // Wait for "Hello, world" to finish.
  while(UUT.data_src !== UUT.DATA_SRC_LOOPBACK) begin
    repeat (15) UART_TESTER.baudrate_delay;
  end

  // Test RGB functionality:
  UART_TESTER.send_byte(8'd82, 1000);
  UART_TESTER.send_byte(8'd71, 1000);
  UART_TESTER.send_byte(8'd66, 1000);
  UART_TESTER.send_byte(8'd114, 1000);
  UART_TESTER.send_byte(8'd103, 1000);
  UART_TESTER.send_byte(8'd98, 1000);
  
  repeat (100) UART_TESTER.baudrate_delay;
  $finish;
end

initial begin
  repeat (1_000_000) @(posedge clk);
  $display("Test timed out!");
  $finish;
end

always #(CLK_PERIOD_NS/2.0) clk = ~clk;

endmodule

