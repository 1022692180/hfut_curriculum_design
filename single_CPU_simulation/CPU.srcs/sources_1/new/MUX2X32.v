//32位2选1数据选择器
module MUX2X32(A1,A2,S,Y);
    input [31:0]A1,A2;
    input S;
    output [31:0]Y;
    assign Y = (S == 1'b1) ? A2 : A1;
endmodule