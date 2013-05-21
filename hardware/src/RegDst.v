//-----------------------------------------------------------------------------
//  Module: RegDst
//  Desc: determine the write back address for register
//  Inputs Interface:
//    rdE: rd field
//    rtE: rt field
//    regDst: control signal for selecting, 00 for rdE, 01 for rtE, 10 for 31
//  Output Interface:
//    wa : write back address for register
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module RegDst (
               input  [1:0] regDst,
               input  [4:0] rdE, 
               input  [4:0] rtE, 
               output [4:0] wa
);
    reg [4:0] tmp;
 
    assign wa = tmp; 

    always @(*) begin
        case(regDst)
            2'b00:   tmp = rdE;
            2'b01:   tmp = rtE; 
            2'b10:   tmp = 31; 
            default: tmp = rdE; 
        endcase
    end  //end always
        

endmodule