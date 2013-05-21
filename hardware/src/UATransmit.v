module UATransmit(
  input   Clock,
  input   Reset,

  input   [7:0] DataIn,
  input         DataInValid,
  output        DataInReady,

  output        SOut
);
  // for log2 function
  `include "util.vh"

  //--|Parameters|--------------------------------------------------------------

  parameter   ClockFreq         =   100_000_000;
  parameter   BaudRate          =   115_200;

  // See diagram in the lab guide
  localparam  SymbolEdgeTime    =   ClockFreq / BaudRate;
  localparam  ClockCounterWidth =   log2(SymbolEdgeTime);

  //--|Solution|----------------------------------------------------------------
   wire SymbolEdge;
   wire Start;
   wire TXRunning;
   
   reg [3:0] BitCounter;
   reg [9:0] TXShift;
   reg dout;
   reg [ClockCounterWidth-1:0] ClockCounter;

   //Goes high at every symbol edge
   assign SymbolEdge = (ClockCounter == SymbolEdgeTime - 1);

   assign Start = DataInValid && !TXRunning;

   assign TXRunning = BitCounter != 4'd10;

   //Outputs
   assign DataInReady = !TXRunning;
   assign SOut = dout;

   // Counts cycles until a single symbol is done
   always @ (posedge Clock) begin
      ClockCounter <= (Start || Reset || SymbolEdge) ? 0 : ClockCounter + 1;
   end


    always @ (posedge Clock) begin
        if (Reset) begin
	       BitCounter <= 10;
        end else if (Start) begin
	       BitCounter <= 0;
        end else if (SymbolEdge && TXRunning) begin
	       BitCounter <= BitCounter + 1;
	       dout <= TXShift[BitCounter]; 
        end
    end

   
    //Shift Register
    always @(posedge Clock) begin
        if (Start) TXShift <= {1'b1, DataIn, 1'b0};
    end
   
endmodule
