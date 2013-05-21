//-----------------------------------------------------------------------------
//  Module: UARTMap
//-----------------------------------------------------------------------------

module UARTMap (
               input  clk,
               input  reset,
               input  RX,
               input memRdE, 
               input memWrtE, 
               input  [31:0] rtd,
               input  [31:0] memAddrE,
               input  [31:0] memAddrM,
               input memRdM,               
               output TX,
               output [31:0] encodedDataM
);
    wire [7:0] DataIn;
    wire DataInValid;
    wire DataOutReady;
    
    wire DataInReady;
    wire [7:0] DataOut;
    wire DataOutValid;

    reg [31:0] tmp;
    
    assign DataIn = rtd[7:0];
    assign DataInValid  =  (memAddrE == 32'h80000008) && (memWrtE == 1) && (reset == 0);
    assign DataOutReady =  (memAddrE == 32'h8000000c) && (memRdE == 1)  && (reset == 0);     
    assign encodedDataM = tmp;


    UART UART(
    	.Clock(clk),
    	.Reset(reset),
    	.DataIn(DataIn),
    	.DataInValid(DataInValid),
    	.DataInReady(DataInReady),
    	.DataOut(DataOut),
    	.DataOutValid(DataOutValid),
    	.DataOutReady(DataOutReady),
    	.SIn(RX),
    	.SOut(TX)
    );
    
    always @(posedge clk) begin
        if(reset)
            tmp <= 0;
        else if( (memAddrM == 32'h80000000) && (memRdM == 1))
            tmp <= {24'b0, DataInReady};
        else if( (memAddrM == 32'h80000004) && (memRdM == 1))
            tmp <= {24'b0, DataOutValid};
        else if( (memAddrM == 32'h8000000c) && (memRdM == 1))
            tmp <= { {24{DataOut[7]}}, DataOut}; 
        else
            tmp <= 0;
    end
    
    



endmodule