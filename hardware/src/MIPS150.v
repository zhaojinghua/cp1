
module MIPS150(
    input clk, 
    input rst,
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);

// Use this as the top-level module for your CPU. You
// will likely want to break control and datapath out
// into separate modules that you instantiate here.
    
    
    //control inside dataPath already
    DataPath data_path(     
    	.clk(clk),
    	.rst(rst),
    	.RX(FPGA_SERIAL_RX),
    	.TX(FPGA_SERIAL_TX)
    );


endmodule
    

