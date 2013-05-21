//-----------------------------------------------------------------------------
//  Module: WrtEnCtrl
//  Desc: write enable signal for DMEM and IMEM
//  Inputs Interface:
//    addr: memory address
//    byteOffset: 2-bits byte offset
//    opcode
//  Output Interface:
//    Dwea: write enable signal for Data Memory
//    Iwea: write enable signal for Inst Memory
//  Author: Zi Wu
//-----------------------------------------------------------------------------

`include "Opcode.vh"

module WrtEnCtrl(
               input [31:0] addr,
               input [1:0] byteOffset,
               input [5:0] opcode, 
               output [3:0] Dwea, 
               output [3:0] Iwea
);

    wire dmem, imem;
    assign dmem = (addr[31] == 1'b0) && (addr[28] == 1'b1);
    assign imem = (addr[31] == 1'b0) && (addr[29] == 1'b1); 

    reg [3:0] Dwea_tmp, Iwea_tmp;
    assign Dwea = Dwea_tmp;
    assign Iwea = Iwea_tmp; 
    
    always @(*) begin
        if(dmem) begin
            case(opcode)
                `SB: begin
                    case(byteOffset)
                        2'b00: Dwea_tmp = 4'b1000;
                        2'b01: Dwea_tmp = 4'b0100;
                        2'b10: Dwea_tmp = 4'b0010;
                        2'b11: Dwea_tmp = 4'b0001;
                    endcase
                end
                
                `SH: begin
                    case(byteOffset[1])
                        1'b0: Dwea_tmp = 4'b1100;
                        1'b1: Dwea_tmp = 4'b0011;
                    endcase
                end
                
                `SW: begin
                    Dwea_tmp = 4'b1111;
                end
            
                default:
                    Dwea_tmp = 4'b0; 
       
            endcase
            
        end // end if
        else
            Dwea_tmp = 4'b0; 
    end //end always
    
    
    always @(*) begin
        if(imem) begin
            case(opcode)
                `SB: begin
                    case(byteOffset)
                        2'b00: Iwea_tmp = 4'b1000;
                        2'b01: Iwea_tmp = 4'b0100;
                        2'b10: Iwea_tmp = 4'b0010;
                        2'b11: Iwea_tmp = 4'b0001;
                    endcase
                end
                
                `SH: begin
                    case(byteOffset[1])
                        1'b0: Iwea_tmp = 4'b1100;
                        1'b1: Iwea_tmp = 4'b0011;
                    endcase
                end
                
                `SW: begin
                    Iwea_tmp = 4'b1111;
                end
            
                default:
                    Iwea_tmp = 4'b0; 
       
            endcase
            
        end // end if
        else
            Iwea_tmp = 4'b0; 
    end //end always
    
    
    
endmodule


