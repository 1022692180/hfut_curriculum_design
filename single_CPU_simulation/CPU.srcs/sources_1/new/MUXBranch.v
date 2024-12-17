//32位2选1数据选择器
module MUXBranch(A1,A2,S,Y);
    input [31:0]A1,A2;
    input [2:0]S;//Branch zero bne/beq
    output [31:0]Y;
    function [31:0]select;
        input [31:0]A1,A2;
        input [2:0]S;
        case(S)
            3'b101:select = A2;
            3'b110:select = A2;
            default:select = A1;
        endcase
    endfunction
    assign Y = select(A1,A2,S);
endmodule