//  Module: ExtenderTestBench
//  Desc:   test bench for Extender module

`timescale 1ns / 1ps

module ExtenderTestBench();

    parameter Halfcycle = 5; //half period is 5ns
    
    localparam Cycle = 2*Halfcycle;
    
    reg Clock;
    
    // Clock Signal generation:
    initial Clock = 0; 
    always #(Halfcycle) Clock = ~Clock;
    

    //inputs for testing module
    reg [15:0] imm;
    reg signExt;
    //outputs from testing module         
    wire [31:0] extImm; 

    //reference outputs
    reg [31:0] REFextImm;     
   

    // Task for checking output
    task checkOutput;
        input [15:0] imm;
        input signExt;
        if ( extImm !== REFextImm ) begin
            $display("FAIL: Incorrect result for imm = %b and signExt = %b:", imm, signExt);
            $display("FAIL: Incorrect result extImm = %b", extImm);
            $finish();
        end
        else begin
            $display("PASS: imm = %b and signExt = %b:", imm, signExt);
        end
    endtask

    //This is where the modules being tested are instantiated. 
    Extender extender_test(
    	.signExtImm(signExt),
    	.imm(imm),
    	.extImm(extImm)
    );

   initial begin
        // Testing logic:
    $display("\n\n HARD CODED TEST CASES for Extender Module\n"); 
    
        imm = 16'b0000_1110_1011_0111;
        signExt = 1'b1;
        REFextImm = 32'b0000_0000_0000_0000_0_00011_10101_10111;

        #1;
        checkOutput(imm, signExt);
        
        
        
        imm = 16'b1000_1110_1011_0111;
        signExt = 1'b1;
        REFextImm = 32'b1111_1111_1111_1111_1000_1110_1011_0111;

        #1;
        checkOutput(imm, signExt);
        
        
        
        imm = 16'b1_00011_10101_10111;
        signExt = 1'b0;
        REFextImm = 32'b0000_0000_0000_0000_1000_1110_1011_0111;

        #1;
        checkOutput(imm, signExt);
        
        

        $display("\n\nALL TESTS PASSED!");
        $finish();
    end

endmodule
