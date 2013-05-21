//  Module: InstDecodeTestBench
//  Desc:   test bench for instruction decode module

`timescale 1ns / 1ps

module InstDecodeTestBench();

    parameter Halfcycle = 5; //half period is 5ns
    
    localparam Cycle = 2*Halfcycle;
    
    reg Clock;
    
    // Clock Signal generation:
    initial Clock = 0; 
    always #(Halfcycle) Clock = ~Clock;
    

    //inputs for testing module
    reg [31:0] inst;
    //outputs from testing module 
    wire [5:0] opcode, funct;     
    wire [4:0] rs, rt, rd, shamt;           
    wire [25:0] target;         
    wire [15:0] imm;         
    wire [105:0] DUTout; 

    assign DUTout = {opcode, funct, rs, rt, rd, shamt, target, imm}; 

    //reference outputs
    reg [5:0] ref_opcode, ref_funct;     
    reg [4:0] ref_rs, ref_rt, ref_rd, ref_shamt; 
    reg [25:0] ref_target;           
    reg [15:0] ref_imm;     
    wire [105:0] REFout; 
    assign REFout = {ref_opcode, ref_funct, ref_rs, ref_rt, ref_rd, ref_shamt, ref_target, ref_imm};     


    // Task for checking output
    task checkOutput;
        input [31:0] inst;
        if ( REFout !== DUTout ) begin
            $display("FAIL: Incorrect result for inst %b:", inst);
            //$display("\tA: 0x%h, B: 0x%h, DUTout: 0x%h, REFout: 0x%h", A, B, DUTout, REFout);
            $finish();
        end
        else begin
            $display("PASS: inst %b", inst);
            //$display("\tA: 0x%h, B: 0x%h, DUTout: 0x%h, REFout: 0x%h", A, B, DUTout, REFout);
        end
    endtask

    //This is where the modules being tested are instantiated. 
   InstDecode inst_decode(
   	.inst(inst),
   	.opcode(opcode),
   	.funct(funct),
   	.rs(rs),
   	.rt(rt),
   	.rd(rd),
   	.shamt(shamt),
   	.imm(imm),
   	.target(target)
   );

   initial begin
    	// Testing logic:
	$display("\n\n HARD CODED TEST CASES\n"); 
	
	    inst = 32'b100001_00011_00010_10101_10001_000010;
	    ref_opcode = 6'b100001;
        ref_funct = 6'b000010; 
        ref_rs = 5'b00011;
        ref_rt = 5'b00010;
        ref_rd = 5'b10101; 
        ref_shamt = 5'b10001; 
	    ref_target =  26'b00011_00010_10101_10001_000010;      
        ref_imm = 16'b10101_10001_000010; 

        #1;
        checkOutput(inst);
        
        inst = 32'b100000_00010_00110_10101_10000_000010;
        ref_opcode = 6'b100000;
        ref_funct = 6'b000010; 
        ref_rs = 5'b00010;
        ref_rt = 5'b00110;
        ref_rd = 5'b10101; 
        ref_shamt = 5'b10000; 
        ref_target =  26'b00010_00110_10101_10000_000010;      
        ref_imm = 16'b10101_10000_000010; 

        #1;
        checkOutput(inst);

        $display("\n\nALL TESTS PASSED!");
        $finish();
    end

endmodule
