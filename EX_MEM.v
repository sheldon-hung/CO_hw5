module EX_MEM( clk_i, EX_adder2, MEM_adder2, EX_ALUresult, MEM_ALUresult, EX_ReadData2, MEM_ReadData2, EX_WriteReg, MEM_WriteReg, EX_RegWrite, MEM_RegWrite, EX_Branch, MEM_Branch, EX_Zero, MEM_Zero, EX_MemtoReg, MEM_MemtoReg, EX_MemRead, MEM_MemRead, EX_MemWrite, MEM_MemWrite);
    input  clk_i;

    input  [32-1:0] EX_adder2, EX_ALUresult, EX_ReadData2;
    output [32-1:0] MEM_adder2, MEM_ALUresult, MEM_ReadData2;
    input  [5-1:0]  EX_WriteReg;
    output [5-1:0]  MEM_WriteReg;

    input  EX_RegWrite, EX_Branch, EX_Zero, EX_MemtoReg, EX_MemRead, EX_MemWrite;
    output MEM_RegWrite, MEM_Branch, MEM_Zero, MEM_MemtoReg, MEM_MemRead, MEM_MemWrite;

    reg    [32-1:0] MEM_adder2 = 32'd0, MEM_ALUresult = 32'd0, MEM_ReadData2 = 32'd0;
    reg    [5-1:0]  MEM_WriteReg = 5'd0;
    reg    MEM_RegWrite = 1'b0, MEM_Branch = 1'b0, MEM_Zero = 1'b0, MEM_MemtoReg = 1'b0, MEM_MemRead = 1'b0, MEM_MemWrite = 1'b0;

    always @(posedge clk_i) begin
        MEM_adder2 <= EX_adder2;
        MEM_ALUresult <= EX_ALUresult;
        MEM_ReadData2 <= EX_ReadData2;
        MEM_WriteReg <= EX_WriteReg;

        MEM_RegWrite <= EX_RegWrite;
        MEM_Branch <= EX_Branch;
        MEM_Zero <= EX_Zero;
        MEM_MemtoReg <= EX_MemtoReg;
        MEM_MemRead <= EX_MemRead;
        MEM_MemWrite <= EX_MemWrite;
    end

endmodule