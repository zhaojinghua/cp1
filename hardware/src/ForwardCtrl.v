//-----------------------------------------------------------------------------
//  Module: ForwardCtrl
//  Desc: handle forwarding for pipeline
//  Inputs Interface:
//    rs: rs filed in Execute Stage
//    rt: rt field in Execute Stage
//    wa: wa in Memory Stage
//    memRd: memory read in Execute Stage (i.e not a loading inst)
//    regWE: reg write enable signal in Memory Stage
//  Output Interface:
//    fwRs, fwRt: 1 for forwarding, 0 otherwise
//  Author: Zi Wu
//-----------------------------------------------------------------------------
module ForwardCtrl(
            input  [4:0] rs,
            input  [4:0] rt,
            input  [4:0] wa,
            //input  memRd, 
            input  regWE, 
            output fwRs, 
            output fwRt
);

    assign fwRs = (rs == wa) && (rs != 0) && (regWE == 1);
    assign fwRt = (rt == wa) && (rt != 0) && (regWE == 1); 
    

endmodule
