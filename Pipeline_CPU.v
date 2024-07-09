module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
//IF
wire [32-1:0] pc_i, pc_o, IF_adder1, IF_instr;
//ID
wire [32-1:0] ID_adder1, ID_instr, ID_SignExtend, ID_ReadData1, ID_ReadData2;
wire [3-1:0]  ID_ALUOp;
wire          ID_ALUSrc, ID_RegDst, ID_Branch, ID_MemRead, ID_MemWrite, ID_RegWrite, ID_MemtoReg;
//EX
wire [32-1:0] EX_adder1, EX_ReadData1, EX_ReadData2, EX_SignExtend, EX_adder2, EX_ALUresult, ALUSrc2;
wire [5-1:0]  EX_rt, EX_rd, EX_WriteReg;
wire [4-1:0]  ALUoperation;
wire [3-1:0]  EX_ALUOp;
wire          EX_ALUSrc, EX_RegDst, EX_Branch, EX_MemRead, EX_MemWrite, EX_RegWrite, EX_MemtoReg, EX_Zero, overflow;
//MEM
wire [32-1:0] MEM_adder2, MEM_ReadData2, MEM_ALUresult, MEM_ReadData;
wire [5-1:0]  MEM_WriteReg;
wire          MEM_RegWrite, MEM_Branch, MEM_Zero, MEM_PCSrc, MEM_MemRead, MEM_MemWrite;
//WB
wire [32-1:0] WB_ReadData, WB_ALUresult, WB_WriteData;
wire [5-1:0]  WB_WriteReg;
wire          WB_RegWrite, WB_MemtoReg;

//modules
Program_Counter PC(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .pc_in_i(pc_i),
        .pc_out_o(pc_o)
);

Adder Adder1( //next instruction
        .src1_i(pc_o),
        .src2_i(32'd4),
        .sum_o(IF_adder1)
);

Mux2to1 #(.size(32)) Mux_branch(
        .data0_i(IF_adder1),
        .data1_i(MEM_adder2),
        .select_i(MEM_PCSrc),
        .data_o(pc_i)
);

Instr_Memory IM(
        .pc_addr_i(pc_o),
        .instr_o(IF_instr)
);
//--------------------------------------IF
IF_ID IF_ID(
        .clk_i(clk_i),
        .IF_adder1(IF_adder1),
        .ID_adder1(ID_adder1),
        .IF_instr(IF_instr),
        .ID_instr(ID_instr)
);
//--------------------------------------ID
Decoder Control(
        .instr_op_i(ID_instr[31:26]),
	.RegWrite_o(ID_RegWrite),
	.ALUOp_o(ID_ALUOp),
	.ALUSrc_o(ID_ALUSrc),
	.RegDst_o(ID_RegDst),
	.Branch_o(ID_Branch),
	.MemWrite_o(ID_MemWrite),
	.MemRead_o(ID_MemRead),
	.MemtoReg_o(ID_MemtoReg)
);

Reg_File RF(
        .clk_i(clk_i),
	.rst_n(rst_n),
        .RSaddr_i(ID_instr[25:21]),
        .RTaddr_i(ID_instr[20:16]),
        .Wrtaddr_i(WB_WriteReg),
        .Wrtdata_i(WB_WriteData),
        .RegWrite_i(WB_RegWrite),
        .RSdata_o(ID_ReadData1),
        .RTdata_o(ID_ReadData2)
);

Sign_Extend SE(
        .data_i(ID_instr[15:0]),
        .data_o(ID_SignExtend)
);
//--------------------------------------ID
ID_EX ID_EX(
        .clk_i(clk_i),
        .ID_adder1(ID_adder1),
        .EX_adder1(EX_adder1),
        .ID_ReadData1(ID_ReadData1),
        .EX_ReadData1(EX_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .EX_ReadData2(EX_ReadData2),
        .ID_SignExtend(ID_SignExtend),
        .EX_SignExtend(EX_SignExtend),
        .ID_rt(ID_instr[20:16]),
        .EX_rt(EX_rt),
        .ID_rd(ID_instr[15:11]),
        .EX_rd(EX_rd),
        .ID_RegWrite(ID_RegWrite),
        .EX_RegWrite(EX_RegWrite),
        .ID_MemtoReg(ID_MemtoReg),
        .EX_MemtoReg(EX_MemtoReg),
        .ID_Branch(ID_Branch),
        .EX_Branch(EX_Branch),
        .ID_MemRead(ID_MemRead),
        .EX_MemRead(EX_MemRead),
        .ID_MemWrite(ID_MemWrite),
        .EX_MemWrite(EX_MemWrite),
        .ID_ALUSrc(ID_ALUSrc),
        .EX_ALUSrc(EX_ALUSrc),
        .ID_ALUOp(ID_ALUOp),
        .EX_ALUOp(EX_ALUOp),
        .ID_RegDst(ID_RegDst),
        .EX_RegDst(EX_RegDst)
);
//--------------------------------------EX
Adder Adder2( //branch
        .src1_i(EX_adder1),
        .src2_i({EX_SignExtend[29:0], 2'b00}), //shift left 2
        .sum_o(EX_adder2)
);

Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(EX_ReadData2),
        .data1_i(EX_SignExtend),
        .select_i(EX_ALUSrc),
        .data_o(ALUSrc2)
);

ALU ALU(
	.aluSrc1(EX_ReadData1),
	.aluSrc2(ALUSrc2),
	.ALU_operation_i(ALUoperation),
	.result(EX_ALUresult),
	.zero(EX_Zero),
	.overflow(overflow)
);

ALU_Ctrl AC(
        .funct_i(EX_SignExtend[5:0]),
        .ALUOp_i(EX_ALUOp),
        .ALU_operation_o(ALUoperation)
);

Mux2to1 #(.size(5)) RegisterDestination(
        .data0_i(EX_rt),
        .data1_i(EX_rd),
        .select_i(EX_RegDst),
        .data_o(EX_WriteReg)
);
//--------------------------------------EX
EX_MEM EX_MEM(
        .clk_i(clk_i),
        .EX_adder2(EX_adder2),
        .MEM_adder2(MEM_adder2),
        .EX_ALUresult(EX_ALUresult),
        .MEM_ALUresult(MEM_ALUresult),
        .EX_ReadData2(EX_ReadData2),
        .MEM_ReadData2(MEM_ReadData2),
        .EX_WriteReg(EX_WriteReg),
        .MEM_WriteReg(MEM_WriteReg),
        .EX_RegWrite(EX_RegWrite),
        .MEM_RegWrite(MEM_RegWrite),
        .EX_Branch(EX_Branch),
        .MEM_Branch(MEM_Branch),
        .EX_Zero(EX_Zero),
        .MEM_Zero(MEM_Zero),
        .EX_MemtoReg(EX_MemtoReg),
        .MEM_MemtoReg(MEM_MemtoReg),
        .EX_MemRead(EX_MemRead),
        .MEM_MemRead(MEM_MemRead),
        .EX_MemWrite(EX_MemWrite),
        .MEM_MemWrite(MEM_MemWrite)
);
//--------------------------------------MEM
assign MEM_PCSrc = MEM_Branch & MEM_Zero;

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(MEM_ALUresult),
	.data_i(MEM_ReadData2),
	.MemRead_i(MEM_MemRead),
	.MemWrite_i(MEM_MemWrite),
	.data_o(MEM_ReadData)
);
//--------------------------------------MEM
MEM_WB MEM_WB(
        .clk_i(clk_i),
        .MEM_ReadData(MEM_ReadData),
        .WB_ReadData(WB_ReadData),
        .MEM_ALUresult(MEM_ALUresult),
        .WB_ALUresult(WB_ALUresult),
        .MEM_WriteReg(MEM_WriteReg),
        .WB_WriteReg(WB_WriteReg),
        .MEM_RegWrite(MEM_RegWrite),
        .WB_RegWrite(WB_RegWrite),
        .MEM_MemtoReg(MEM_MemtoReg),
        .WB_MemtoReg(WB_MemtoReg)
);
//--------------------------------------WB
Mux2to1 #(.size(32)) MemorytoRegister(
        .data0_i(WB_ReadData),
        .data1_i(WB_ALUresult),
        .select_i(WB_MemtoReg),
        .data_o(WB_WriteData)
);

endmodule



