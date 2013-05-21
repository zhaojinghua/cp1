//-----------------------------------------------------------------------------
//  Module: AddrPartition
//  Desc: partition memory address
//  Inputs Interface:
//    ALUOut
//  Output Interface:
//    memAddr: memory address
//    byteOffset: 2-bit column offset
//    is_UART: determine whether is I/O device, 1 for yes
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module AddrPartition (
               input   [31:0] ALUOut,
               output  [31:0] memAddr, 
               output  [1:0]  byteOffset, 
               output  is_UART
);
    assign memAddr = {ALUOut[31:2], 2'b00};
    assign byteOffset = ALUOut[1:0];
    assign is_UART = (ALUOut[31:28] == 4'b1000); 

endmodule