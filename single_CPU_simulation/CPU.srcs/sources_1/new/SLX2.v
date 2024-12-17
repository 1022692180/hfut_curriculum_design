module SLX2(
    input [31:0]imm,
    output [31:0]sl_imm
    );
    assign sl_imm = {14'b00000000000000,imm[15:0],2'b00};
endmodule
