module MEM_WB( clk_i, MEM_ReadData, WB_ReadData, MEM_ALUresult, WB_ALUresult, MEM_WriteReg, WB_WriteReg, MEM_RegWrite, WB_RegWrite, MEM_MemtoReg, WB_MemtoReg);
    input  clk_i;
    
    input  [32-1:0] MEM_ReadData, MEM_ALUresult;
    output [32-1:0] WB_ReadData, WB_ALUresult;
    input  [5-1:0]  MEM_WriteReg;
    output [5-1:0]  WB_WriteReg;

    input  MEM_RegWrite, MEM_MemtoReg;
    output WB_RegWrite, WB_MemtoReg;

    reg    [32-1:0] WB_ReadData = 32'd0, WB_ALUresult = 32'd0;
    reg    [5-1:0]  WB_WriteReg = 5'd0;
    reg    WB_RegWrite = 1'b0, WB_MemtoReg = 1'b0;

    always @(posedge clk_i) begin
        WB_ReadData <= MEM_ReadData;
        WB_ALUresult <= MEM_ALUresult;
        WB_WriteReg <= MEM_WriteReg;

        WB_RegWrite <= MEM_RegWrite;
        WB_MemtoReg <= MEM_MemtoReg;
    end

endmodule