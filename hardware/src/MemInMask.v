//-----------------------------------------------------------------------------
//  Module: MemInMask
//  Desc: handle the data to be stored in memory
//  Inputs Interface:
//    opcode
//    byteOffset
//    rtd: data to be stored
//  Output Interface:
//    DataInMasked
//  Author: Zi Wu
//-----------------------------------------------------------------------------

`include "Opcode.vh"

module MemInMask (
               input  [5:0] opcode,
               //input  [1:0] byteOffset, 
               input  [31:0] rtd, 
               output [31:0]  DataInMasked
);

    reg [31:0] Data_tmp;
    
    assign DataInMasked = Data_tmp;  
    
    always @(*) begin
        case(opcode)
            //wea[3:0] will handle which one to store
            `SB: Data_tmp = {rtd[7:0], rtd[7:0], rtd[7:0], rtd[7:0]}; 
            `SH: Data_tmp = {rtd[15:0], rtd[15:0]};
            default: Data_tmp = rtd; 
        endcase
    end

endmodule