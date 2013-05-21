//-----------------------------------------------------------------------------
//  Module: InstDecode
//  Desc: decode instruction into corresponding fields
//  Inputs Interface:
//    inst: the instruction to be decoded
//  Output Interface:
//    opcode, funct
//    rs, rt, rd, shamt
//    imm, target
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module InstDecode(
               input  [31:0] inst,
               output [5:0]  opcode, 
               output [5:0]  funct,
               output [4:0]  rs, 
               output [4:0]  rt, 
               output [4:0]  rd, 
               output [4:0]  shamt,
               output [15:0] imm,
               output [25:0] target
);

    assign opcode = inst[31:26];
    assign funct  = inst[5:0];
    assign rs     = inst[25:21];
    assign rt     = inst[20:16];
    assign rd     = inst[15:11];
    assign shamt  = inst[10:6];
    assign imm    = inst[15:0];
    assign target = inst[25:0];

endmodule
