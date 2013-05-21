//---------------------------------------------------------------
//  Module: UARTEncode
//  Desc: Encoding UART Data to be written back to register file
//  Inputs Interface:
//    addr: memory address
//    DataInReady
//    DataOutValid
//    DataOut
//    memRd
//    reset
//  Output Interface:
//    EncodedData
//  Author: Zi Wu
//----------------------------------------------------------------

module UARTEncode (
        input [31:0] addr,
        input DataInReady,
        input DataOutValid,
        input [7:0] DataOut,
        input memRd,
        input reset,
        output [31:0] EncodedData
);

    reg [31:0] Data_tmp;
    assign EncodedData = Data_tmp;

    always @(*) begin                               // posedge clk?
        if(reset)
            Data_tmp = 0;
        else if( (addr == 32'h80000000) && (memRd == 1))
            Data_tmp = {31'b0, DataInReady};
        else if( (addr == 32'h80000004) && (memRd == 1))
            Data_tmp = {31'b0, DataOutValid};
        else if( (addr == 32'h8000000c) && (memRd == 1))
            Data_tmp = { {24{DataOut[7]}}, DataOut};  //sign ext?
        else
            Data_tmp = 0;
    end

endmodule