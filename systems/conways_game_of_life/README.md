# Conway's Game of Life
In this lab you will implement a version of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life).

Here's a ![block diagram](docs/conway-bd-1.png) of what we'll be making.

# Sign off checklist.
* [ ] You *MUST* work in pairs for this assignment!
* [ ] Lab log/design notebook. You can put your notes in this README, linked google doc, etc.
* [ ] Clean comments in all verilog files.
* [ ] Working implementation of a single conway cell.
* [ ] Working game of life (`test_conway_system`) simulation.
* [ ] Custom `waves_conway_system` target.
* [ ] Design the missing section of the led_array_driver for N=5.
  *   [ ] Optional: do custom logic for N=8.
  * [ ] Excel: make it work for arbitrary NxN led arrays.
* [ ] Build the led array circuit on your breadboard.
* [ ] Edit `conway_system.xdc` to match how you wired up the LED array.
* [ ] Working 5x5 grid on FPGA with different initial conditions.
* [ ] Be able to describe `conway_system.sv` (the top level module) at a high level.
* [ ] Excel: Working 8x8 grid with an interesting and customized initial condition.

# Reference Materials
- [Cmod A7 FPGA Reference](https://digilent.com/reference/programmable-logic/cmod-a7/reference-manual)
- [8x8 LED Display Datasheet](https://cdn-shop.adafruit.com/datasheets/454datasheet.pdf) 

# Lab Walkthrough
There should be enough examples to get you started, but in general:
- `make test_foo` will compile and run a simulation that you can then view with `make waves_foo`. 
- `make foo.bit` calls Vivado from the command line - *you will need to run `setup_cafe` first!*
- `make program_foo` calls Vivado from the command line - this assumes you've finished the cable driver part of the installation.

`conway_system.sv` is the top level hardware description. This one has shows you some pretty advanced features that you will understand by end of class, but don't need to fully understand now. That said, *always skim the top level file to see the inputs, outputs, and parameters* for the module!

## 1. Double check components.
This lab requires working decoders, comparators, adders, and a register. Make sure that you have all of those signed off before proceeding. Solutions will be provided on an as needed basis.

## 2. Conway's Game of Life - Cell Module
Edit `conway_cell.sv` and use `test_conway_cell.sv` to implement combinational logic and a flip flop that follows these rules:
1. Any live cell with two or three live neighbours survives (becomes 1'b1 at posedge clk).
2. Any dead cell with three live neighbours becomes a live cell (becomes 1'b1 at posedge clk).
3. All other live cells die in the next generation. Similarly, all other dead cells stay dead. (becomes 1'b0 at posedge clk).

Once it works, you can run `make test_conways_game_of_life` to see a simulation of the full grid! 

*NOTE* you will need to edit the Makefile and `*HDL` variables to include any files used to make `conway_cell.sv` or your `pulse_generator.sv`.

See if you can follow the examples in set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { rgb[0] }]; #IO_L14P_T2_SRCC_16 Sch=led0_r


`conways_game_of_life.sv` to change your initial conditions. If you change N you can simulate larger and larger grids! I put a fun `pulsar` example in for `N == 15`.

## 3. LED Array Driver
- Read the datasheet of the LED driver to implement combinational logic that can drive the row and column pins of the LED array. This is pretty challenging, but think about what the voltages need to be at the row pin or the column pin based on the cell status and the status of our x decoder.

## 4. Build the circuit! 

Draw up a schematic for how you think the LED array should be connected based on the datasheets. You only need to implement a 5x5 grid for the lab (though the 8x8 is much more fun). To avoid damaging LEDs contact an instructor before powering the circuit up! Note that you can connect to any of the pio pins of the FPGA.

## 5. Flashing the FPGA

### a) Xilinx Design Constraint files.

Edit the `conways_game_of_life.xdc` file to match the real circuit you built on a breadboard.

### b) Flashing the FPGA
The micro-usb connector on the FPGA is very fragile - *avoid plugging and unplugging directly into that!* Instead unplug and replug from the extension cable when power on and off.

*NEVER modify your breadboard circuitry while the FPGA is plugged in!*

The `conway_system.sv` file has some simple logic for the built in LEDs based on the buttons. Alter this if to make sure that your tools can still flash the FPGA.

You can make the bitstream with: `make conway_system.bit` and program it with `make program_conway_system`

If it doesn't work, debug in simulation first!