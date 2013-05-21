//-----------------------------------------------------------------------------
//  Module: Extender
//  Desc: handle extension for immediate field
//  Inputs Interface:
//    signExtImm: 1 for sign ext, 0 for zero ext
//    imm: immediate field
//  Output Interface:
//    extImm: extended immediate
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module Extender(
               input signExtImm,
               input  [15:0] imm,
               output  [31:0] extImm
);
    assign extImm = (signExtImm == 1)? {{16{imm[15]}}, imm} : {16'b0, imm}; 
endmodule