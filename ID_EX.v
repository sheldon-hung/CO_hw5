module ID_EX( clk_i, ID_adder1, EX_adder1, ID_ReadData1, EX_ReadData1, ID_ReadData2,      EX_ReadData2, ID_SignExtend, EX_SignExtend, ID_rt, EX_rt, ID_rd, EX_rd, ID_RegWrite, EX_RegWrite, ID_MemtoReg, EX_MemtoReg, ID_Branch, EX_Branch, ID_MemRead, EX_MemRead, ID_MemWrite, EX_MemWrite, ID_ALUSrc, EX_ALUSrc, ID_ALUOp, EX_ALUOp, ID_RegDst, EX_RegDst);
    input  clk_i;

    input  [32-1:0] ID_adder1, ID_ReadData1, ID_ReadData2, ID_SignExtend;
    output [32-1:0] EX_adder1, EX_ReadData1, EX_ReadData2, EX_SignExtend;
    input  [5-1:0]  ID_rt, ID_rd;
    output [5-1:0]  EX_rt, EX_rd;

    input  [3-1:0]  ID_ALUOp;
    output [3-1:0]  EX_ALUOp;
    input  ID_RegWrite, ID_MemtoReg, ID_Branch, ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_RegDst;
    output EX_RegWrite, EX_MemtoReg, EX_Branch, EX_MemRead, EX_MemWrite, EX_ALUSrc, EX_RegDst;

    reg    [32-1:0] EX_adder1 = 32'd0, EX_ReadData1 = 32'd0, EX_ReadData2 = 32'd0, EX_SignExtend = 32'd0;
    reg    [5-1:0]  EX_rt = 5'd0, EX_rd = 5'd0;
    reg    [3-1:0]  EX_ALUOp = 3'b000;
    reg    EX_RegWrite = 1'b0, EX_MemtoReg = 1'b0, EX_Branch = 1'b0, EX_MemRead = 1'b0, EX_MemWrite = 1'b0, EX_ALUSrc = 1'b0, EX_RegDst = 1'b0;


    always @(posedge clk_i) begin
        EX_adder1 <= ID_adder1;
        EX_ReadData1 <= ID_ReadData1;
        EX_ReadData2 <= ID_ReadData2;
        EX_SignExtend <= ID_SignExtend;
        EX_rt <= ID_rt;
        EX_rd <= ID_rd;

        EX_ALUOp <= ID_ALUOp;
        EX_RegWrite <= ID_RegWrite;
        EX_MemtoReg <= ID_MemtoReg;
        EX_Branch <= ID_Branch;
        EX_MemRead <= ID_MemRead;
        EX_MemWrite <= ID_MemWrite;
        EX_ALUSrc <= ID_ALUSrc;
        EX_RegDst <= ID_RegDst;

    end

endmodule