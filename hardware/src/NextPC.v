//-----------------------------------------------------------------------------
//  Module: NextPC
//  Desc: determine what the next PC is 
//  Inputs Interface:
//    rst: reset
//    pc_sel: 00 for PC+4, 01 for J/JAL, 10 for JR/JALR, 11 for Branch
//    currentPC: current PC
//    rsd: R[$rs] for JAL/JALR
//    target: for J/JAL
//    extImm: for Branch
//  Output Interface:
//    nextPC: next PC
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module NextPC (
               input  rst,
               input  [1:0]  pc_sel,
               input  [31:0] pcF, 
               input  [31:0] pcE,
               input  [31:0] rsd,
               input  [25:0] target, 
               input  [31:0] extImm, 
               output [31:0] pc 
);
    reg [31:0] tmp;
    
    assign pc = tmp; 

    always @(*) begin
        if(rst)
            tmp = 0; 
        else begin
            case(pc_sel)
                2'b01:   tmp = {pcE[31:28], target, 2'b00};
                2'b10:   tmp = rsd; 
                2'b11:   tmp = pcE + 4 + (extImm << 2); 
                default: tmp = pcF + 4; 
            endcase
        end
        
    end  //end always
        

endmodule