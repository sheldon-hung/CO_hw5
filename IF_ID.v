module IF_ID( clk_i, IF_adder1, ID_adder1, IF_instr, ID_instr);
    input  clk_i;

    input  [32-1:0] IF_adder1, IF_instr;
    output [32-1:0] ID_adder1, ID_instr;

    reg    [32-1:0] ID_adder1 = 32'd0, ID_instr = 32'd0;

    always @(posedge clk_i) begin
        ID_adder1 <= IF_adder1;
        ID_instr  <= IF_instr;
    end

endmodule