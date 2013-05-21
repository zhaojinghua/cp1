//-----------------------------------------------------------------------------
//  Module: PCSel
//  Desc: Control signal for selecting the next PC
//  Inputs Interface:
//    opcode: opcode field of instruction
//    funct: function field on instruction
//    rsd: R[$rs] used for branch comparison
//    rtd: R[$rt] used for branch comparison
//    rt : rt field used to determine whether BLTZ or BGEZ
//  Output Interface:
//    pc_sel: control signal for selecting the next PC
//            00 for PC+4, 01 for J/JAL, 10 for JR/JALR, 11 for Branch
//  Author: Zi Wu
//-----------------------------------------------------------------------------

`include "Opcode.vh"

module PCSel (
               input  [5:0]  opcode, 
               input  [5:0]  funct,
               input  [31:0] rsd, 
               input  [31:0] rtd,
               input  [4:0]  rt,
               output [1:0]  pc_sel
             );
    reg [1:0] tmp;
    assign pc_sel = tmp; 
    
    always @(*) begin
        case(opcode)
            `J, `JAL: tmp = 2'b01;
            
            `RTYPE:   tmp = ((funct == `JR) || (funct == `JALR)) ? 2'b10 : 2'b00; 
            
            `BEQ:     tmp = (rsd == rtd)? 2'b11 : 2'b00;
            
            `BNE:     tmp = (rsd != rtd)? 2'b11 : 2'b00;
            
            `BLEZ:    tmp = ($signed(rsd) <= 0)? 2'b11 : 2'b00;
            
            `BGTZ:    tmp = ($signed(rsd) > 0) ? 2'b11 : 2'b00;
            
            `BLTZ, `BGEZ: begin
                if(rt == 5'b00000) //BLTZ
                    tmp = ($signed(rsd) < 0)  ? 2'b11 : 2'b00;  
                else  //BGEZ
                    tmp = ($signed(rsd) >= 0) ? 2'b11 : 2'b00; 
            end
            
            default: 
                tmp = 2'b00; 
            
        endcase
        
    end  //end always
        

endmodule
