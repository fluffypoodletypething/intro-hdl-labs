# UART Hello World

In most CS classes you learn how to print "Hello, world." in minutes, but in this class we're going to make that work in SystemVerilog hardware on our FPGA.

The goal is a system that can communicate over the built-in FPGA USB-UART conversion.

The system has an RX (receive) channel that can receive characters. If it receives the characters 'r', 'g', or 'b' (in either case) it will change the color of the tricolor LED to match (see `uart_hello_world.sv`). 

The system also has a TX (transmit) channel. We don't technically need this to make a programmable arduino style microcontroller, but it can't hurt! Plus it lets us print "Hello world" with an FSM.

## Checklist
* Reach out if you do not have a working `edge_detector` by end of week, you might need it.
* [ ] PASS: Implement a working UART RX channel. Your simulation should clearly show state strings (not just numbers). Look up `translate filter file` in the `gtkwave` manual to see how to use the sample `components/tests/uart_states.txt` file to do so.
* [ ] PASS: Learn how to modify the system to support more colors than just red, blue, and green.
* [ ] Excel: Implement a working UART TX channel (uncomment the `LOOPBACK_TEST` directive in the `test_uart_driver` testbench to check).
* [ ] Excel: Modify the printed message (check the python script in tests).