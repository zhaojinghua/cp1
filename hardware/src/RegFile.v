//-----------------------------------------------------------------------------
//  Module: RegFile
//  Desc: An array of 32 32-bit registers
//  Inputs Interface:
//    clk: Clock signal
//    ra1: first read address (asynchronous)
//    ra2: second read address (asynchronous)
//    wa: write address (synchronous)
//    we: write enable (synchronous)
//    wd: data to write (synchronous)
//  Output Interface:
//    rd1: data stored at address ra1
//    rd2: data stored at address ra2
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module RegFile(input clk,
               input we,
               input  [4:0] ra1, 
               input  [4:0] ra2, 
               input  [4:0] wa,
               input  [31:0] wd,
               output [31:0] rd1, 
               output [31:0] rd2);

    // Implement your register file here, then delete this comment.

    (* ram_style = "distributed" *) reg [31:0] register[0:31];

    assign rd1 = (ra1 != 0) ? register[ra1] : 0;
    assign rd2 = (ra2 != 0) ? register[ra2] : 0;

    always @(posedge clk) begin
        if (we && (wa != 0)) 
            register[wa] <= wd;
    end

endmodule
