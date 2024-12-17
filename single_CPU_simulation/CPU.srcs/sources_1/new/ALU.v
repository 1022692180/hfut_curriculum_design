//4位加减器实现
module AS_4(X, Y, Cin, S, Cout);// Cin:进位进位    S:运算结果   Cout:高位进位
    input [3:0] X, Y;
    input Cin;
    output [3:0] S;
    output Cout;
    
    // 声明中间变量
    wire [2:0] carry;

    // 第一位全加器
    assign S[0] = X[0] ^ Y[0] ^ Cin;
    assign carry[0] = (X[0] & Y[0]) | (X[0] & Cin) | (Y[0] & Cin);

    // 第二位全加器
    assign S[1] = X[1] ^ Y[1] ^ carry[0];
    assign carry[1] = (X[1] & Y[1]) | (X[1] & carry[0]) | (Y[1] & carry[0]);

    // 第三位全加器
    assign S[2] = X[2] ^ Y[2] ^ carry[1];
    assign carry[2] = (X[2] & Y[2]) | (X[2] & carry[1]) | (Y[2] & carry[1]);

    // 第四位全加器
    assign S[3] = X[3] ^ Y[3] ^ carry[2];
    assign Cout = (X[3] & Y[3]) | (X[3] & carry[2]) | (Y[3] & carry[2]);
endmodule

//32位加减器的实现
module AS_32(X, Y, Cin, S, Cout);
    input [31:0] X, Y;
    input Cin;
    output [31:0] S;
    output Cout;

    wire Cout0, Cout1, Cout2, Cout3, Cout4, Cout5, Cout6, Cout7;

    // 实例化8个AS_4模块
    AS_4 add0(X[3:0], Y[3:0], Cin, S[3:0], Cout0);
    AS_4 add1(X[7:4], Y[7:4], Cout0, S[7:4], Cout1);
    AS_4 add2(X[11:8], Y[11:8], Cout1, S[11:8], Cout2);
    AS_4 add3(X[15:12], Y[15:12], Cout2, S[15:12], Cout3);
    AS_4 add4(X[19:16], Y[19:16], Cout3, S[19:16], Cout4);
    AS_4 add5(X[23:20], Y[23:20], Cout4, S[23:20], Cout5);
    AS_4 add6(X[27:24], Y[27:24], Cout5, S[27:24], Cout6);
    AS_4 add7(X[31:28], Y[31:28], Cout6, S[31:28], Cout7);

    // 将最后一个AS_4模块的进位输出作为整个AS_32模块的进位输出
    assign Cout = Cout7;
endmodule

//ALU[3] = 0：逻辑   ALU[3] = 1：算术     ALU[0] = 0：左移   ALU[0] = 1：右移
module SHIFTER(X,Sa,ALU,res_sh);
    input [31:0]X;
    input [4:0]Sa;
    input [3:0]ALU;
    output [31:0]res_sh;
    
    wire sign = X[31] & ALU[3];//符号位是负数的拓展条件：1.最高位是1  2.算术
    
    wire [31:0]T4, T3, T2, T1, T0, S4, S3, S2, S1;
    wire [31:0]L1u, L1d, L2u, L2d, L3u, L3d, L4u, L4d, L5u, L5d;//左移和右移的结果
    
   //Sa[4]
    assign L1u = { X[15:0],16'b0000000000000000};
    assign L1d = {{16{sign}},X[31:16]};
    MUX2X32 M1l(L1u, L1d, ALU[0], T4);
    MUX2X32 M1r(X, T4, Sa[4], S4);
    //Sa[3]
    assign L2u = { S4[23:0],8'b00000000};
    assign L2d = {{8{sign}},S4[31:8]};
    MUX2X32 M2l(L2u, L2d, ALU[0], T3);
    MUX2X32 M2r(S4, T3, Sa[3], S3);
    //Sa[2]
    assign L3u = { S3[27:0],4'b0000};
    assign L3d = {{4{sign}},S3[31:4]};
    MUX2X32 M3l(L3u, L3d, ALU[0], T2);
    MUX2X32 M3r(S3, T2, Sa[2], S2);
    //Sa[1]
    assign L4u = { S2[29:0],2'b00};
    assign L4d = {{2{sign}},S2[31:2]};
    MUX2X32 M4l(L4u, L4d, ALU[0], T1);
    MUX2X32 M4r(S2, T1, Sa[1], S1);
    //Sa[0]
    assign L5u = { S1[30:0],1'b0};
    assign L5d = {{sign},S1[31:1]};
    MUX2X32 M5l(L5u, L5d, ALU[0], T0);
    MUX2X32 M5r(S1, T0, Sa[0], res_sh);
endmodule

//根据ALU控制信号选择输出结果
module MUXALU(res_add,res_sub,res_and,res_or,res_xor,res_nor,res_sh,res_lui,Aluc,R);
    input [31:0]res_add,res_sub,res_and,res_or,res_xor,res_nor,res_sh,res_lui;
    input [3:0]Aluc;
    output [31:0]R;
    function [31:0]select;
        input [31:0]res_add,res_sub,res_and,res_or,res_xor,res_nor,res_sh,res_lui;
        input [3:0]Aluc;
            case(Aluc)
                4'b0000:select = res_add;//add
                4'b0001:select = res_sub;//sub
                4'b0010:select = res_and;//and
                4'b0011:select = res_or;//or
                4'b0100:select = res_xor;//xor
                4'b0101:select = res_nor;//nor
                4'b0110:select = res_sh;//sll
                4'b0111:select = res_sh;//srl
                4'b1001:select = res_sh;//sra
                4'b1000:select = res_lui;//lui
            endcase
    endfunction
    assign R = select(res_add,res_sub,res_and,res_or,res_xor,res_nor,res_sh,res_lui,Aluc);
endmodule

//运算器的实现
module ALU(X,Y,Aluc,R,Z);
    input[31:0]X,Y;
    input[3:0]Aluc;
    output[31:0]R;
    output Z;
    
    wire[31:0]res_add,res_sub,res_and,res_or,res_xor,res_nor,res_sh,res_lui;
    wire Cout1,Cout2;
    
    AS_32 add32(X, Y, Aluc[0], res_add, Cout1);
    AS_32 sub32(X, ~Y, Aluc[0], res_sub, Cout2);
    assign res_and = X & Y;
    assign res_or = X | Y;
    assign res_xor = X ^ Y;
    assign res_nor = X ^ ~Y;
    SHIFTER shift(Y,X[10:6],Aluc[3:0],res_sh);
    assign res_lui = {Y[15:0],16'h0000000000000000};
    MUXALU select(res_add, res_sub, res_and, res_or, res_xor, res_nor, res_sh, res_lui, Aluc[3:0], R);
    
    assign Z = (R == 0)?1:0;
endmodule
