//-----------------------------------------------------------------------------
//  Module: Control
//  Desc: control signal for datapath
//  Inputs Interface:
//      opcode
//      funct
//      rsd: already forwarded rsd (busA)
//      rtd: already forwarded rtd (busB)
//      rt: rt field used to distinguish BLTZ/BGEZ
//  Output Interface:
//      pc_sel:     signal for selecting next pc
//      ALUop:      ALU operation 
//      regDst:     writeBack register dest, 00 for rdE, 01 for rtE, 10 for 31(JAL)  
//      regWE:      register file write enable      
//      memToReg:   memory to register, 1 for yes, 0 otherwise
//      memRd:      memory read(i.e load instruction)
//      memWrt:     memory write(i.e. store instruction)
//      signExtImm: 1 for sign ext, 0 for zero ext
//      sel_imm:    1 for selecting immediate as one of the input to ALU
//      sel_shamt:  1 for selecting shamt as one of the input to ALU
//      jal_r:      1 for JAL or JALR, 0 otherwise
//  Author: Zi Wu
//-----------------------------------------------------------------------------

`include "Opcode.vh"

module Control(
        input [5:0] opcode, 
        input [5:0] funct,
        input [31:0] rsd, 
        input [31:0] rtd,
        input [4:0]  rt,      
        
        output [1:0] pc_sel,        
        output [3:0] ALUop,        
        output reg [1:0] regDst,    //00 for rdE, 01 for rtE, 10 for 31
        output reg regWE,
        output reg memToReg,
        output reg memRd,
        output reg memWrt,
        output reg signExtImm,
        output reg sel_imm,
        output reg sel_shamt,
        output reg jal_r
);

    //submodule for pc_sel
    PCSel nextPCSel(
    	.opcode(opcode),
    	.funct(funct),
    	.rsd(rsd),
    	.rtd(rtd),
    	.rt(rt),
    	.pc_sel(pc_sel)
    );
    
    //submodule for ALUop
    ALUdec aludecode(
    	.funct(funct),
    	.opcode(opcode),
    	.ALUop(ALUop)
    );
    
    always @(*) begin
        case(opcode)
            `LB, `LH, `LW, `LBU, `LHU: begin
                regDst = 2'b01;
                regWE = 1;
                memToReg = 1;
                memRd = 1;
                memWrt = 0;
                signExtImm = 1;
                sel_imm = 1;
                sel_shamt = 0;
                jal_r = 0;
            end  //end loading
                
            
            `SB, `SH, `SW: begin
                regDst = 2'b00;  //dont care
                regWE = 0;
                memToReg = 0;   //dont care
                memRd = 0;
                memWrt = 1; 
                signExtImm = 1;
                sel_imm = 1;
                sel_shamt = 0;
                jal_r = 0;
            end  // end storing
            
            
            `ADDIU, `SLTI, `SLTIU: begin
                regDst = 2'b01;
                regWE = 1;
                memToReg = 0;
                memRd = 0;
                memWrt = 0;
                signExtImm = 1;
                sel_imm = 1;
                sel_shamt = 0;
                jal_r = 0;
            end  
            
            `ANDI, `ORI, `XORI, `LUI: begin
                regDst = 2'b01;
                regWE = 1;
                memToReg = 0;
                memRd = 0;
                memWrt = 0;
                signExtImm = 0;  // dont care for LUI
                sel_imm = 1;
                sel_shamt = 0;
                jal_r = 0;
            end
            
            `RTYPE: begin
                regDst = 2'b00;
                regWE = (funct == `JR) ? 0 : 1;
                memToReg = 0;
                memRd = 0;
                memWrt = 0;
                signExtImm = 0; // dont care
                sel_imm = 0;
                sel_shamt = ((funct == `SLL) || (funct == `SRL) || (funct == `SRA)) ? 1 : 0;
                jal_r = (funct == `JALR) ? 1 : 0;
            end
            
            `J : begin
                regDst = 2'b01;  //dont care
                regWE = 0; 
                memToReg = 0;
                memRd = 0;
                memWrt = 0;
                signExtImm = 0;
                sel_imm = 0;
                sel_shamt = 0;
                jal_r = 0;
            end
            
            `JAL: begin
                regDst = 2'b10; 
                regWE = 1;
                memToReg = 0;
                memRd = 0;
                memWrt = 0; 
                signExtImm = 0; 
                sel_imm = 0;
                sel_shamt = 0;
                jal_r = 1;
            end
            
            `BEQ, `BNE, `BLEZ, `BGTZ, `BLTZ, `BGEZ: begin
                regDst = 2'b00; 
                regWE = 0;
                memToReg = 0;
                memRd = 0;
                memWrt = 0;
                signExtImm = 1;
                sel_imm = 1;
                sel_shamt = 0;
                jal_r = 0;
            end
    
            default: begin
                regDst = 2'b00;
                regWE = 0;
                memToReg = 0;
                memRd = 0;
                memWrt = 0;
                signExtImm = 0;
                sel_imm = 0;
                sel_shamt = 0;
                jal_r = 0;
            end 
          
    
        endcase //opcode
    end //end always
    

endmodule
