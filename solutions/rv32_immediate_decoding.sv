always_comb begin: immediate_decoding
  case(op)
    OP_ITYPE: immediate_src = IMM_SRC_ITYPE;
    OP_STYPE: immediate_src = IMM_SRC_STYPE;
    OP_BTYPE: immediate_src = IMM_SRC_BTYPE;
    OP_JALR : immediate_src = IMM_SRC_ITYPE;
    OP_JAL  : immediate_src = IMM_SRC_JTYPE;
    OP_AUIPC: immediate_src = IMM_SRC_UTYPE;
    OP_LUI  : immediate_src = IMM_SRC_UTYPE;
    default : immediate_src = IMM_SRC_ITYPE; // immediate isn't used under any other op codes, so we could put anything here.
  endcase

  // See Figure 6.27 in the text for why the immediate bit packing is so convoluted.
  case(immediate_src)
    IMM_SRC_ITYPE : begin
      if(funct3 == FUNCT3_SHIFT_RIGHT | funct3 == FUNCT3_SLL) begin
        extended_immediate = {27'b0, IR[24:20]};
      end else begin
        extended_immediate = {{20{IR[31]}}, IR[31:20]}; 
      end
    end
    IMM_SRC_STYPE : extended_immediate = {{20{IR[31]}}, IR[31:25],IR[11:7]};
    IMM_SRC_BTYPE : extended_immediate = {{20{IR[31]}}, IR[7],IR[30:25], IR[11:8], 1'b0};
    IMM_SRC_JTYPE : extended_immediate = {{12{IR[31]}}, IR[19:12], IR[20], IR[30:21], 1'b0};
    IMM_SRC_UTYPE : extended_immediate = {IR[31:12], 12'b0};
    default: extended_immediate = 0;
  endcase
end
