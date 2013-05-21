//-----------------------------------------------------------------------------
//  Module: MemOutMask
//  Desc: mask the output of the block RAM to select appropriate portion of 
//        the 32-bits data
//  Inputs Interface:
//    MemOut: data read from memory
//    opcode: e.g. LB, LH, LW, LBU, LHU, 
//    byteOffset: 2-bit byte offset 
//  Output Interface:
//    DataMasked: 32-bit masked data
//  Author: Zi Wu
//-----------------------------------------------------------------------------

`include "Opcode.vh"

module MemOutMask (
            input  [31:0] MemOut,
            input  [5:0]  opcode,
            input  [1:0]  byteOffset,
            output [31:0] DataMasked
);

    reg [31:0] data_tmp; 
    
    assign DataMasked = data_tmp; 
    
    always @(*) begin
        case(opcode)
            `LB: begin
                case(byteOffset)
                    2'b00: data_tmp = { {24{MemOut[31]}}, MemOut[31:24]}; 
                    2'b01: data_tmp = { {24{MemOut[23]}}, MemOut[23:16]}; 
                    2'b10: data_tmp = { {24{MemOut[15]}}, MemOut[15:8]}; 
                    2'b11: data_tmp = { {24{MemOut[7]}} , MemOut[7:0]}; 
                endcase
            end // end LB
            
            
            `LH: begin
                case(byteOffset[1])
                    1'b0:  data_tmp = { {16{MemOut[31]}} , MemOut[31:16]};
                    1'b1:  data_tmp = { {16{MemOut[15]}} , MemOut[15:0]};
                endcase
            end // end LH
            
            
            `LBU: begin
                case(byteOffset)
                    2'b00: data_tmp = {24'b0, MemOut[31:24]}; 
                    2'b01: data_tmp = {24'b0, MemOut[23:16]}; 
                    2'b10: data_tmp = {24'b0, MemOut[15:8]}; 
                    2'b11: data_tmp = {24'b0, MemOut[7:0]}; 
                endcase
            end // end LBU
        
            
            `LHU: begin
                case(byteOffset[1])
                    1'b0:  data_tmp = {16'b0, MemOut[31:16]};
                    1'b1:  data_tmp = {16'b0, MemOut[15:0]};
                endcase
            end // end LHU
            
        
            `LW : begin    
                data_tmp = MemOut; 
            end // end LHU
            
           
            default: begin
                data_tmp = MemOut;  
            end
            
        endcase //opcode
    
    end // end always

endmodule