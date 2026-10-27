`default_nettype none
`timescale 1ns/1ps

module register_file(
  rst, clk,
  wr_ena, wr_addr, wr_data,
  rd_addr0, rd_data0,
  rd_addr1, rd_data1
);
// Not parametrizing, these widths are defined by the RISC-V Spec.

input wire clk, rst;

// Write channel:
input wire wr_ena;
input wire [4:0] wr_addr;
input wire [31:0] wr_data;

// Two read channels:
input wire [4:0] rd_addr0, rd_addr1;
output logic [31:0] rd_data0, rd_data1;

logic [31:0] x00; 
always_comb x00 = 32'd0; // ties x00 to ground

// DON'T DO THIS:
// logic [31:0] register_file_registers [31:0];
// CAN'T: because that's a RAM. Works in simulation, not synthesis. Technically if you implement it as a distribute ram it sort of works out, but the following more structural representation captures how much hardware/area the register file really takes.



// Aliases (helpful for debugging assembly);
`ifdef SIMULATION
logic [31:0] ra, sp, gp, tp, t0, t1, t2, s0, fp, s1, a0, a1, a2, a3, a4, a5, 
  a6, a7, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, t3, t4, t5, t6;
always_comb begin : REGISTER_ALIASES
  ra = x01; // Return Address
  sp = x02; // Stack Pointer
  gp = x03; // Global Pointer
  tp = x04; // Thread Pointer
  fp = x08; // Frame Pointer
  s0 = x08; // Saved Registers - must be preserved by called functions.
  s1 = x09; 
  s2 = x18;
  s3 = x19;
  s4 = x20;
  s5 = x21;
  s6 = x22;
  s7 = x23;
  s8 = x24;
  s9 = x25;
  s10 = x26;
  s11 = x27;
  t0 = x05; // Temporary values (can be changed by called functions).
  t1 = x06;
  t2 = x07;
  t3 = x28;
  t4 = x29;
  t5 = x30;
  t6 = x31;
  a0 = x10;
  a1 = x11;
  a2 = x12;
  a3 = x13;
  a4 = x14;
  a5 = x15;
  a6 = x16;
  a7 = x17;
end

function void print_state();
  $display("|---------------------------------------|");
  $display("| Register File State                   |");
  $display("|---------------------------------------|");
  $display("| %12s = 0x%8h (%10d)|", "x00, zero", x00, x00);
  $display("| %12s = 0x%8h (%10d)|", "x01, ra", x01, x01);
  $display("| %12s = 0x%8h (%10d)|", "x02, sp", x02, x02);
  $display("| %12s = 0x%8h (%10d)|", "x03, gp", x03, x03);
  $display("| %12s = 0x%8h (%10d)|", "x04, tp", x04, x04);
  $display("| %12s = 0x%8h (%10d)|", "x05, t0", x05, x05);
  $display("| %12s = 0x%8h (%10d)|", "x06, t1", x06, x06);
  $display("| %12s = 0x%8h (%10d)|", "x07, t2", x07, x07);
  $display("| %12s = 0x%8h (%10d)|", "x08, s0", x08, x08);
  $display("| %12s = 0x%8h (%10d)|", "x09, s1", x09, x09);
  $display("| %12s = 0x%8h (%10d)|", "x10, a0", x10, x10);
  $display("| %12s = 0x%8h (%10d)|", "x11, a1", x11, x11);
  $display("| %12s = 0x%8h (%10d)|", "x12, a2", x12, x12);
  $display("| %12s = 0x%8h (%10d)|", "x13, a3", x13, x13);
  $display("| %12s = 0x%8h (%10d)|", "x14, a4", x14, x14);
  $display("| %12s = 0x%8h (%10d)|", "x15, a5", x15, x15);
  $display("| %12s = 0x%8h (%10d)|", "x16, a6", x16, x16);
  $display("| %12s = 0x%8h (%10d)|", "x17, a7", x17, x17);
  $display("| %12s = 0x%8h (%10d)|", "x18, s2", x18, x18); 
  $display("| %12s = 0x%8h (%10d)|", "x19, s3", x19, x19); 
  $display("| %12s = 0x%8h (%10d)|", "x20, s4", x20, x20); 
  $display("| %12s = 0x%8h (%10d)|", "x21, s5", x21, x21); 
  $display("| %12s = 0x%8h (%10d)|", "x22, s6", x22, x22); 
  $display("| %12s = 0x%8h (%10d)|", "x23, s7", x23, x23); 
  $display("| %12s = 0x%8h (%10d)|", "x24, s8", x24, x24); 
  $display("| %12s = 0x%8h (%10d)|", "x25, s9", x25, x25); 
  $display("| %12s = 0x%8h (%10d)|", "x26, s10", x26, x26); 
  $display("| %12s = 0x%8h (%10d)|", "x27, s11", x27, x27); 
  $display("| %12s = 0x%8h (%10d)|", "x28, t3", x28, x28); 
  $display("| %12s = 0x%8h (%10d)|", "x29, t4", x29, x29); 
  $display("| %12s = 0x%8h (%10d)|", "x30, t5", x30, x30); 
  $display("| %12s = 0x%8h (%10d)|", "x31, t6", x31, x31); 
  $display("|---------------------------------------|");
endfunction // print_state

/*
// TODO(avinash) - finish this task for more automated testing.
task dump_state(string file);
  int fd = $fopen("./register_file.txt", "w");
  $fdisplay(fd, "|---------------------------------------|");
  $fdisplay(fd, "| Register File State                   |");
  $fdisplay(fd, "|---------------------------------------|");
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x00, zero", x00, x00);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x01, ra", x01, x01);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x02, sp", x02, x02);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x03, gp", x03, x03);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x04, tp", x04, x04);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x05, t0", x05, x05);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x06, t1", x06, x06);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x07, t2", x07, x07);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x08, s0", x08, x08);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x09, s1", x09, x09);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x10, a0", x10, x10);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x11, a1", x11, x11);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x12, a2", x12, x12);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x13, a3", x13, x13);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x14, a4", x14, x14);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x15, a5", x15, x15);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x16, a6", x16, x16);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x17, a7", x17, x17);
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x18, s2", x18, x18); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x19, s3", x19, x19); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x20, s4", x20, x20); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x21, s5", x21, x21); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x22, s6", x22, x22); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x23, s7", x23, x23); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x24, s8", x24, x24); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x25, s9", x25, x25); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x26, s10", x26, x26); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x27, s11", x27, x27); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x28, t3", x28, x28); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x29, t4", x29, x29); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x30, t5", x30, x30); 
  $fdisplay(fd, "| %12s = 0x%8h (%10d)|", "x31, t6", x31, x31); 
  $fdisplay(fd, "|---------------------------------------|");
  $fclose(fd);
endtask
*/ 

`endif // SIMULATION
endmodule