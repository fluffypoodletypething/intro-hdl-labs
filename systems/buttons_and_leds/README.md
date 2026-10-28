# Buttons and LEDs

This is a simple demo project to show how we can connect our modules to the physical world. It consists of two files, `buttons_and_leds.sv` - the module, and `buttons_and_leds.lpf` a Lattice Preference File file. LPF files show how ports of a module (the inputs and outputs) connect to real pins on physical devices. As an example, the following lines connect and configure pin `B2` on the FPGA to `leds[0]` in the HDL.

```
LOCATE COMP "leds[0]" SITE "B2";
IOBUF PORT "leds[0]" PULLMODE=NONE IO_TYPE=LVCMOS33 DRIVE=4;
```


You'll be given (mostly) complete LPF files for various systems, but keep in mind that they are based on the FPGA chip *and* the schematic of the board that you are working with. You should always read the schematic of any board you work with.

The goal of this demo is to give us a simple mix of combinational and sequential logic. The two normal LEDs are driven by some gates (see the module for details) in a simple way. The RGB LED (rgb[2:0] = {r,g,b}, respectively) should switch between two colors defined in ON_COLOR and OFF_COLOR.

## 1) Do the tools work?
All commands should be run from the `systems` directory.

### a) Simulation
Run `make waves_buttons_and_leds` to show that you can simulate the system.

### b) Synthesis
Show that you can run `make buttons_and_leds.bit` to generate a bitstream that can program the FPGA.

### c) Programming

TODO

## 2) Modifications and Enhancements

### a) Intermediate - Blinky LED
Usually embedded engineers try to blink an LED as the first thing to try. Unfortunately our 12MHz is so fast that if we toggle an LED based on that we'd never see it with our slow human eyes! Can you come up with a sequential circuit that can toggle one of the LEDs at a slower rate? Aim for between 10 and 1 Hz. Hint: you will need an N-bit `adder_n`, a `compare_eq`, and a `register` to build a counter that can do this.

The toggle doesn't work well because of two problems, bouncing, and not being edge sensitive.

### b) Advanced - Edge Detecting
We also don't want to toggle while the button is pressed, just the first time that it is! Can you design an `edge_detector` that outputs high for one clock cycle right after the button has been pressed? There is a prototype and a testbench in the `components` folder. Get feedback on an FSM diagram or table before writing any verilog!

### b) Advanced - Debouncing
Real buttons "bounce" when pressed, that means they go up and down many times before settling at a voltage. We need to implement a debouncer module (prototype *without* test available in `components`) that can filter this signal slightly so that we don't get too many presses. Get feedback on an FSM diagram or table before writing any verilog!
