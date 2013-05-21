//-----------------------------------------------------------------------------
//  Module: UARTCtrl
//  Desc: handshake signal for UART
//  Inputs Interface:
//    reset: reset signal
//    addr: memory address
//    rtd: already forwarding handled R[$rt]
//    memRd: loading instruction or not
//    memWrt: storing instruction or not
//  Output Interface:
//    DataInValid
//    DataIn
//    DataOutReady
//  Author: Zi Wu
//-----------------------------------------------------------------------------

module UARTCtrl (
               input  reset,
               input  [31:0] addr,
               input  [31:0] rtd,
               input  memRd,
               input  memWrt,
               output DataInValid,
               output [7:0] DataIn,
               output DataOutReady
);
    assign DataIn = rtd[7:0];
    assign DataInValid  =  (addr == 32'h80000008) && (memWrt == 1) && (reset == 0);
    assign DataOutReady =  (addr == 32'h8000000c) && (memRd == 1)  && (reset == 0);     
        

endmodule