
module DataPath(
    input clk, 
    input rst,
    input RX,
    output TX
);

// wire declaration for Inst Fetch Stage
    wire  [31:0] InstF;
    reg   [31:0] pcF; 
    wire  [31:0] pc;


//wire declaration for Execution Stage
    reg [31:0] pcE, InstE;
    
    //inst decode outputs 
    wire [5:0] opcodeE, functE;
    wire [4:0] rsE, rtE, rdE, shamtE;
    wire [15:0] immE;
    wire [25:0] targetE; 
    
    wire [31:0] extImmE; 
    
    //control output signals 
    wire [1:0] pc_selE;
    wire [1:0] RegDstE; 
    wire regWE_E; 
    wire memToRegE;
    wire memRdE; 
    wire memWrtE; 
    wire signExtImmE;
    wire sel_immE; 
    wire sel_shamtE;
    wire jal_rE;
    wire [3:0] ALUopE; 
    
    wire [31:0] rsdE;
    wire [31:0] rtdE; 
    wire [31:0] FwRsdE;
    wire [31:0] FwRtdE; 
    wire [31:0] busAE;
    wire [31:0] busBE; 
    wire fwRsE;
    wire fwRtE; 
    
    wire [31:0] ALUOutE;         //output from ALU module 
    wire [31:0] ALUOutSelectedE;  //output from mux selecting ALUOutE and pcE+8
    
    wire [31:0] memAddrE;
    wire [1:0]  byteOffsetE; 
    wire is_UARTE;
    
    wire [4:0] waE;             //reg write back dest
    
    wire [3:0] DweaE;
    wire [3:0] IweaE;
    wire [31:0] dinaE;  
    

    wire DataInValidE;         //may cause problem???
    wire [7:0] DataInE;
    wire DataOutReadyE; 
    
    
//wire declaration for Memory Stage
    reg [31:0] ALUOutSelectedM; 
    reg [4:0] waM; 
    reg regWE_M; 
    reg memToRegM; 
    reg [5:0] opcodeM; 
    reg [1:0] byteOffsetM; 
    reg is_UARTM; 
    reg [31:0] memAddrM; 
    reg memRdM; 

    wire DataInReadyM;      //may cause problem?
    wire [7:0] DataOutM; 
    wire DataOutValidM; 
    
    wire [31:0] EncodedDataM; 
    wire [31:0] doutaM;     //data out from DMEM
    wire [31:0] DataMaskedM; 
    wire [31:0] MemOutDataM; //data selecting from DMEM or UART
    wire [31:0] WrtBackData_M; 
    
    

// Instruction Fetch Stage
    NextPC pcLogic(
    	.rst(rst),
    	.pc_sel(pc_selE),
    	.pcF(pcF),
    	.pcE(pcE),
    	.rsd(FwRsdE),
    	.target(targetE),
    	.extImm(extImmE),
    	.pc(pc)
    );
    
    always @(posedge clk) begin
        if(rst)
            pcF <= 0;
        else
            pcF <= pc; 
    end
    
    
    imem_blk_ram inst_blk_ram(
    	.clka(clk),
    	.ena(1'b1),
    	.wea(IweaE),
    	.addra(memAddrE[13:2]),
    	.dina(dinaE),
    	.clkb(clk),
    	.addrb(pc[13:2]),
    	.doutb(InstF)
    );


// Execution Stage
    always @(posedge clk) begin
        if(rst) begin
            pcE <= 0;
            InstE <= 0;
        end
        else begin
            pcE <= pcF;
            InstE <= InstF;
        end 
    end
    
    InstDecode inst_decode(
    	.inst(InstE),
    	.opcode(opcodeE),
    	.funct(functE),
    	.rs(rsE),
    	.rt(rtE),
    	.rd(rdE),
    	.shamt(shamtE),
    	.imm(immE),
    	.target(targetE)
    );
    
    RegFile reg_file(
    	.clk(clk),
    	.we(regWE_M),
    	.ra1(rsE),
    	.ra2(rtE),
    	.wa(waM),
    	.wd(WrtBackData_M),
    	.rd1(rsdE),
    	.rd2(rtdE)
    );
    
    Control control_signal(
    	.opcode(opcodeE),
    	.funct(functE),
    	.rsd(FwRsdE),
    	.rtd(FwRtdE),
    	.rt(rtE),
    	.pc_sel(pc_selE),
    	.ALUop(ALUopE),
    	.regDst(RegDstE),
    	.regWE(regWE_E),
    	.memToReg(memToRegE),
    	.memRd(memRdE),
    	.memWrt(memWrtE),
    	.signExtImm(signExtImmE),
    	.sel_imm(sel_immE),
    	.sel_shamt(sel_shamtE),
    	.jal_r(jal_rE)
    );
    
    Extender extender(
    	.signExtImm(signExtImmE),
    	.imm(immE),
    	.extImm(extImmE)
    );
    
    ForwardCtrl forwarding(
    	.rs(rsE),
    	.rt(rtE),
    	.wa(waM),
    	//.memRd(memRdE),
    	.regWE(regWE_M),
    	.fwRs(fwRsE),
    	.fwRt(fwRtE)
    );

    ALUInputs alu_inputs(
    	.rsd(rsdE),
    	.rtd(rtdE),
    	.WrtBackData(WrtBackData_M),
    	.extImm(extImmE),
    	.shamt(shamtE),
    	.fwRs(fwRsE),
    	.fwRt(fwRtE),
    	.sel_shamt(sel_shamtE),
    	.sel_imm(sel_immE),
    	.busA(busAE),
    	.busB(busBE),
    	.FwRsd(FwRsdE),
    	.FwRtd(FwRtdE)
    );

    ALU ALU(
    	.A(busAE),
    	.B(busBE),
    	.ALUop(ALUopE),
    	.Out(ALUOutE)
    );
    
    assign ALUOutSelectedE = (jal_rE == 1) ? pcE + 8 : ALUOutE; 
    
    
    RegDst RegDst(
    	.regDst(RegDstE),
    	.rdE(rdE),
    	.rtE(rtE),
    	.wa(waE)
    );
    
    AddrPartition addr_partition(
    	.ALUOut(ALUOutSelectedE),
    	.memAddr(memAddrE),
    	.byteOffset(byteOffsetE),
    	.is_UART(is_UARTE)
    );
    
    WrtEnCtrl mem_WrtEnCtrl(
    	.addr(memAddrE),
    	.byteOffset(byteOffsetE),
    	.opcode(opcodeE),
    	.Dwea(DweaE),
    	.Iwea(IweaE)
    );
    
    MemInMask mem_dina(
    	.opcode(opcodeE),
    	.rtd(FwRtdE),
    	.DataInMasked(dinaE)
    );
    

    
    dmem_blk_ram data_blk_ram(
    	.clka(clk),
    	.ena(1'b1),                //what should this be?
    	.wea(DweaE),
    	.addra(memAddrE[13:2]),
    	.dina(dinaE),
    	.douta(doutaM)
    );


// Memory Stage

    always @(posedge clk) begin
        if(rst == 0) begin
            ALUOutSelectedM <= ALUOutSelectedE;
            waM <= waE; 
            regWE_M <= regWE_E; 
            memToRegM <= memToRegE; 
            opcodeM <= opcodeE;
            byteOffsetM <= byteOffsetE; 
            is_UARTM <= is_UARTE;
            memAddrM <= memAddrE;
            memRdM <= memRdE;
        end  
    end
    
    
    UARTCtrl UART_Ctrl(
        .reset(rst),
        .addr(memAddrE),
        .rtd(FwRtdE),
        .memRd(memRdE),
        .memWrt(memWrtE),
        .DataInValid(DataInValidE),
        .DataIn(DataInE),
        .DataOutReady(DataOutReadyE)
    );
    
    
    UART uart(                  //watch out this module?
        .Clock(clk),
        .Reset(rst),
        .DataIn(DataInE),
        .DataInValid(DataInValidE),
        .DataInReady(DataInReadyM),
        .DataOut(DataOutM),
        .DataOutValid(DataOutValidM),
        .DataOutReady(DataOutReadyE),
        .SIn(RX),
        .SOut(TX)
    );
    
    UARTEncode UART_DataEncode(
    	.addr(memAddrM),
    	.DataInReady(DataInReadyM),
    	.DataOutValid(DataOutValidM),
    	.DataOut(DataOutM),
    	.memRd(memRdM),
    	.reset(rst),
    	.EncodedData(EncodedDataM)
    );
    
    
    
    /*
    UARTMap uartMap(
    	.clk(clk),
    	.reset(rst),
    	.RX(RX),
    	.memRdE(memRdE),
    	.memWrtE(memWrtE),
    	.rtd(FwRtdE),
    	.memAddrE(memAddrE),
    	.memAddrM(memAddrM),
    	.memRdM(memRdM),
    	.TX(TX),
    	.encodedDataM(EncodedDataM)
    );
    */
    

    MemOutMask mem_dataOutMask(
    	.MemOut(doutaM),
    	.opcode(opcodeM),
    	.byteOffset(byteOffsetM),
    	.DataMasked(DataMaskedM)
    );
    
    assign MemOutDataM = (is_UARTM == 1) ? EncodedDataM : DataMaskedM; 
    assign WrtBackData_M = (memToRegM == 1)? MemOutDataM : ALUOutSelectedM; 


endmodule
    