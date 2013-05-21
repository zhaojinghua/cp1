// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

module RegFileTestbench();

  parameter Halfcycle = 5; //half period is 5ns

  localparam Cycle = 2*Halfcycle;

  reg Clock;

  // Clock Sinal generation:
  initial Clock = 0; 
  always #(Halfcycle) Clock = ~Clock;

  // Register and wires to test the RegFile
  reg [4:0] ra1;
  reg [4:0] ra2;
  reg [4:0] wa;
  reg we;
  reg [31:0] wd;
  wire [31:0] rd1;
  wire [31:0] rd2;

  RegFile DUT(.clk(Clock),
              .we(we),
              .ra1(ra1),
              .ra2(ra2),
              .wa(wa),
              .wd(wd),
              .rd1(rd1),
              .rd2(rd2));
  

  // Testing logic:
  initial begin
    #1;
    // Verify that writing to reg 0 is a nop
    we = 1;
    ra1 = 0;
    ra2 = 0;
    wa = 0;     //writing to reg 0
    wd = 1;
    #Cycle;
    if (rd1 == 0)
        $display("Test Pass! Writing to reg 0 is a nop.");
    else begin
     $display("Test Fail! Writing to reg 0 is not a nop.");
     $display("Got %b, Expected %b", rd1, 0);
     $finish();
    end
    #Cycle;
    
    // Verify that data written to any other register is returned the same cycle
    we = 1;
    wa = 1;
    wd = 10;    //writing to reg 1 with data 10
    ra1 = 1;    //reading reg 1
    ra2 = 1;
    #Halfcycle;
    if (rd1 == 10)
        $display("Test Pass! Data written to any other register is returned the same cycle.");
    else begin
     $display("Test Fail! Data written to any other register is not returned the same cycle.");
     $display("Got %b, Expected %b", rd1, 10);
     $finish();
    end
    #Cycle;

    // Verify that the we pin prevents data from being written
    we = 1;
    wa = 2;
    wd = 100;    //writing to reg 2 with data 100, for reference
    #Cycle;
    we = 0;
    wa = 2;
    wd = 20;
    ra1 = 2;    //reading reg 2 in next cycle
    #Halfcycle;
    if (rd1 == 100)
        $display("Test Pass! we pin prevents data from being written. ");
    else begin
     $display("Test Fail! we pin does not prevent data from being written.");
     $display("Got %d, Expected %d", rd1, 100);
     $finish();
    end
    #Cycle;
    
    // Verify the reads are asynchronous
    //R[1] = 10, R[2] = 100;
    ra1 = 1;
    #2;
    if (rd1 != 10) begin
        $display("Test Fail! reads are not asynchronous.");
        $display("Got %d, Expected %d", rd1, 10);
        $finish();
    end
    ra1 = 2;
    #2;
    if (rd1 != 100) begin
        $display("Test Fail! reads are not asynchronous.");
        $display("Got %d, Expected %d", rd1, 100);
        $finish();
    end
    $display("Test Pass! Reads are asynchronous.");
    
   
    $display("All tests passed!");
    $finish();
  end
endmodule
