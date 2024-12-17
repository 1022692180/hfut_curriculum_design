//32位2选1数据选择器
module MUXWrAddr(A1,A2,A3,S,Y);
    input [4:0]A1,A2,A3;
    input [1:0]S;
    output [4:0]Y;
    function [4:0]select;
        input [4:0]A1,A2,A3;
        input [1:0]S;
        case(S)
            2'b00:select = A1;
            2'b01:select = A2;
            2'b10:select = A3;
        endcase
    endfunction
    assign Y = select(A1,A2,A3,S);
endmodule