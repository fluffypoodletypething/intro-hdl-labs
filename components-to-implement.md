# List of Components to Implement

Note: take a look at the SystemVerilog cheatsheet in the docs folter.

Note: Most of the test benches are not self checking and require you to double
check the printed truth table and waveforms.

The Fall 2023 version of the course was a bit chaotic due to being restructured
if I recall correctly. It went from assigned homeworks to just a list of
components you had to implement on your own time. I am not sure what original
bugs remain in this copy.

I lost the original homework assignments from 2022 and the suggested order to
implement the modules from 2023, so this is just a guess from looking at it.


# adder_1

A full adder takes in 3 one-bit inputs: `a`, `b`, and `c_in`, and outputs `sum` and `c_out`.

Fill out the truth table:

| `a` | `b` | `c_in` | `sum` | `c_out` |
|-----|-----|--------|-------|---------|
| 0   | 0   | 0      |       |         |
| 0   | 0   | 1      |       |         |
| 0   | 1   | 0      |       |         |
| 0   | 1   | 1      |       |         |
| 1   | 0   | 0      |       |         |
| 1   | 0   | 1      |       |         |
| 1   | 1   | 0      |       |         |
| 1   | 1   | 1      |       |         |


In SystemVerilog, `always_comb` is used for combinational logic, that is, it
does not store state.

```systemverilog
input wire a, b;  // Pretend like these are being driven from somewhere else

logic ex_xor, ex_and, ex_or, ex_inv;

always_comb begin
    ex_xor = a ^ b;
    ex_and = a & b;
    ex_or = a | b;
    ex_inv = ~a;
end
```

`wire` is a net that the module cannot drive dirrectly with an `always_` block.
It is driven elsewhere (either as inputs to the module or from another module
inside the module.

You can run `make test_adder_1` from `components` to simulate your design. The
testbench is stored under `tests/test_adder_1.sv`. Testbenches, for the most
part, will not be synthesizable logic.

You can view waveforms with `make waves_adder_1`. Alternatively call `gtkwave`
directly with `gtkwave adder_1.fst` (the output wave dump). This should apply
for all of the modules in here. Play around with gtkwave for a bit. It will be
essential to debug sequential logic later.

# Decoders

A decoder has N inputs and $2^N$ outputs. The outputs are labeled 0 through N-1.
Only 1 output is high at a time, the numbered output corresponding to the binary
input value. There is also an enable pin, active high in this case. If the chip
is not enabled (`ena` is low), all outputs should be low.

Decoders are useful for driving a small matrix, for example an LED matrix.

Start with `decoder_1_to_2.sv` and implement with boolean logic.

You can use 3 one-to-two decoders (with active low enable) to implement a
two-to-four decoder. Think about how to do this; draw it on paper.

You can instantiate a module in another module with

```systemverilog
module_name instance_name(.port(net1), .port(net2),...);
```

Try to implement the other decoders using the smaller decoders you have
implemented thus far.

If you get stuck, you can look at the `solutions` directory at the root of this repo.

# Mux

Implement the 2 to 1 mux `mux2.sv`.

Implement the larger muxes. You can use the smaller muxes to implement the
larger muxes.

It will make more sense to use `case` statements in more sophisticated designs,
but for getting familiar with digital logic design use this for now.

# adder_n, parameters, and generate statements

From this point you have done basic boolean logic
and also instantiated submodules within modules.

Look up a ripple carry adder. `adder_n.sv` is already implemented. Take a look
at it and note the following.

- Sometimes, you want to parametrize instances of a module. For example, do you
  want an 8-bit or a 16-bit adder.

- Parameters allow you to do this. You can specify the value when you create an
  instance. The parameter can be used when declaring the widths of nets
  `[N-1:0]`, as well as in generate statements.

- Sometimes you want to programmatically instantiate a certain amount of
  submodules. Maybe this depends on a parameter. These are a bit confusing,
  since a for loop looks like a proceedure. This is NOT procedural code; it is
  closer to preprocessor macros in C. Think of unrolling the loop and replacing
  the value of the variables declared as `genvar` each time. For example, this
  module will instantiate `N` full adder modules, 8 will be created if N is 8,
  32 will be created if N is 32.

## Testbench

Study the testbench `tests/test_adder_n.sv`. Look at what is doing. Why might
the net types for `logic` and `wire` be reversed to how they are defined in the
modules?

## Other Notes

You obviously don't have to implement every adder like this. In digital design
you will most likely write:

```systemverilog
wire [7:0] a, b;
logic [8:0] sum; // One larger for the carry out bit

always_comb begin
    sum = a + b;
end
```

Because this class included intro to digital logic, everything was explicitally
done from a structural level working from gates up. This is not frequently done
unless you are getting really specific.

# Comparitors

Implement `comparitor_eq.sv` and `comparator_lt.sv`. For less than, consider the
inputs signed. Think about twos compliment, using an adder for subtraction, and
other things you would need to detect for this to work correctly.

# Sequential Logic and Register

Take a look at `register.sv`. It is a very minimal example of sequential logic.
A register is just a collection of N d flip flops to store a multiple bit
number.

Notice that `<=` is used to assign in the `always_ff` block. Look up the
difference between `=` and `<=` in SystemVerilog.

# Edge Detector

An edge detector generates a high output for one pulse after an edge has been
detected. Assuming the input `in` is already syncronized with the clock, the
timing diagram looks as follows:

```
    clk _'_'_'_'_'_'_'_'_'_'_'_'_'_'
    
     in _______''''''____'''_______
     
posedge _______'_________'_________

negedge _____________'______'______
```

Think of how this can be implemented by storing the previous value of `in` in a
flip flop. Fill out the truth table and what you should expect to see.

Hint: this truth table is not done as a binary count; it's easier to reason
about the behavior of the edge detector this way.

| `prev_in` | `in` | `posedge` | `negedge` |
|-----------|------|-----------|-----------|
| 0         | 0    |           |           |
| 0         | 1    |           |           |
| 1         | 1    |           |           |
| 1         | 0    |           |           |

If `in` is not synchronized to a clock, add another flip flop before the one you
are using to store the prior state. That will synchronize it on the output (Q)
side of the flip flop

# Pulse Generator

The pulse generator output goes high for 1 clock cycle every N counts. You can
implemenet using your adder and comparitors as well as a register, or you can
try doing it using `+`, `<`, etc (despite what the original comments in the file
say).

This block and the following blocks will be easiest to implement using an
accumulating counter of some sort.

# Triangle Generator

A tringle wave has an N bit digital output that counts up linearly until the max
value, then counts down linearly.

Idealy, it does not stay at the max or min value for more than 1 cycle; use
waves to double check that you implemented your state machine correctly for this behavior.

# PWM

Make a module that takes in an N bit input and has a 1 bit output. The output
should be high for the duty cycle corresponding to the input.

# Register File

A CPU has a "register file," which is a collection of general purpose registers.
A typical 32-bit or 64-bit RISC instruction set will have 32 general purpose
registers in the register file.

Take a look at Harris and Harris (Digital Design and Computer Architecture) or
at Patterson and Hennessy (Computer Organization and Design) if you are
unfamiliar with how this is organized.

Use the `register` and the various mux modules to implement the register file.
You can also use case statements and do it more behaviorally. See the solutions
if you get stuck. The `ifdef` and `endif` statements are similar to C, it will
includes or cutout the code encapulated wihtin them depending on if something is
defined or not (the structural or behavioral switch).

# More Advanced Components

TODO: Take the I2C driver and SPI driver from the 2022 version and add them back
into this.
