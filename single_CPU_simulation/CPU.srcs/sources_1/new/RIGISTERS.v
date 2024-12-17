//5-32译码器的实现
module DEC5T32E(WriteReg,En,RegAddr);
    input [4:0] WriteReg;
    input En;//使能信号
    output reg[31:0] RegAddr;
    always@(En or WriteReg)
            begin
                if(En)
                    begin
                        case(WriteReg)
                            5'b00000:RegAddr=32'b00000000000000000000000000000001;
                            5'b00001:RegAddr=32'b00000000000000000000000000000010;
                            5'b00010:RegAddr=32'b00000000000000000000000000000100;
                            5'b00011:RegAddr=32'b00000000000000000000000000001000;
                            5'b00100:RegAddr=32'b00000000000000000000000000010000;
                            5'b00101:RegAddr=32'b00000000000000000000000000100000;
                            5'b00110:RegAddr=32'b00000000000000000000000001000000;
                            5'b00111:RegAddr=32'b00000000000000000000000010000000;
                            5'b01000:RegAddr=32'b00000000000000000000000100000000;
                            5'b01001:RegAddr=32'b00000000000000000000001000000000;
                            5'b01010:RegAddr=32'b00000000000000000000010000000000;
                            5'b01011:RegAddr=32'b00000000000000000000100000000000;
                            5'b01100:RegAddr=32'b00000000000000000001000000000000;
                            5'b01101:RegAddr=32'b00000000000000000010000000000000;
                            5'b01110:RegAddr=32'b00000000000000000100000000000000;
                            5'b01111:RegAddr=32'b00000000000000001000000000000000;
                            5'b10000:RegAddr=32'b00000000000000010000000000000000;
                            5'b10001:RegAddr=32'b00000000000000100000000000000000;
                            5'b10010:RegAddr=32'b00000000000001000000000000000000;
                            5'b10011:RegAddr=32'b00000000000010000000000000000000;
                            5'b10100:RegAddr=32'b00000000000100000000000000000000;
                            5'b10101:RegAddr=32'b00000000001000000000000000000000;
                            5'b10110:RegAddr=32'b00000000010000000000000000000000;
                            5'b10111:RegAddr=32'b00000000100000000000000000000000;
                            5'b11000:RegAddr=32'b00000001000000000000000000000000;
                            5'b11001:RegAddr=32'b00000010000000000000000000000000;
                            5'b11010:RegAddr=32'b00000100000000000000000000000000;
                            5'b11011:RegAddr=32'b00001000000000000000000000000000;
                            5'b11100:RegAddr=32'b00010000000000000000000000000000;
                            5'b11101:RegAddr=32'b00100000000000000000000000000000;
                            5'b11110:RegAddr=32'b01000000000000000000000000000000;
                            5'b11111:RegAddr=32'b10000000000000000000000000000000;
                        endcase
                    end
                else
                    RegAddr=32'b00000000000000000000000000000000;
            end
endmodule

//D触发器
module D_Latch(D,En,Q,Qn);
    input D,En;
    output Q,Qn;
    assign Q = (D & En) | ~Qn;
    assign Qn = (~D & En) | ~Q;
endmodule

//D锁存器的实现
module D_FFEC(WriteData,clk,En,reset,Q,Qn);
    input WriteData,clk;
    input En,reset;
    output Q,Qn;
    wire D;
    wire Q0,Qn0;
    assign D = ((Q & ~En) | (WriteData & En)) & reset;
    D_Latch d0(D,clk,Q0,Qn0);//时钟高电平读取数据
    D_Latch d1(Q0,~clk,Q,Qn);//时钟低电平向寄存器存储数据
endmodule

module D_FFEC32(WriteData,clk,En,reset,Q,Qn);
    input[31:0]WriteData;
    input clk,En,reset;
    output[31:0]Q,Qn;
    D_FFEC d0(WriteData[0],clk,En,reset,Q[0],Qn[0]);
    D_FFEC d1(WriteData[1],clk,En,reset,Q[1],Qn[1]);
    D_FFEC d2(WriteData[2],clk,En,reset,Q[2],Qn[2]);
    D_FFEC d3(WriteData[3],clk,En,reset,Q[3],Qn[3]);
    D_FFEC d4(WriteData[4],clk,En,reset,Q[4],Qn[4]);
    D_FFEC d5(WriteData[5],clk,En,reset,Q[5],Qn[5]);
    D_FFEC d6(WriteData[6],clk,En,reset,Q[6],Qn[6]);
    D_FFEC d7(WriteData[7],clk,En,reset,Q[7],Qn[7]);
    D_FFEC d8(WriteData[8],clk,En,reset,Q[8],Qn[8]);
    D_FFEC d9(WriteData[9],clk,En,reset,Q[9],Qn[9]);
    D_FFEC d10(WriteData[10],clk,En,reset,Q[10],Qn[10]);
    D_FFEC d11(WriteData[11],clk,En,reset,Q[11],Qn[11]);
    D_FFEC d12(WriteData[12],clk,En,reset,Q[12],Qn[12]);
    D_FFEC d13(WriteData[13],clk,En,reset,Q[13],Qn[13]);
    D_FFEC d14(WriteData[14],clk,En,reset,Q[14],Qn[14]);
    D_FFEC d15(WriteData[15],clk,En,reset,Q[15],Qn[15]);
    D_FFEC d16(WriteData[16],clk,En,reset,Q[16],Qn[16]);
    D_FFEC d17(WriteData[17],clk,En,reset,Q[17],Qn[17]);
    D_FFEC d18(WriteData[18],clk,En,reset,Q[18],Qn[18]);
    D_FFEC d19(WriteData[19],clk,En,reset,Q[19],Qn[19]);
    D_FFEC d20(WriteData[20],clk,En,reset,Q[20],Qn[20]);
    D_FFEC d21(WriteData[21],clk,En,reset,Q[21],Qn[21]);
    D_FFEC d22(WriteData[22],clk,En,reset,Q[22],Qn[22]);
    D_FFEC d23(WriteData[23],clk,En,reset,Q[23],Qn[23]);
    D_FFEC d24(WriteData[24],clk,En,reset,Q[24],Qn[24]);
    D_FFEC d25(WriteData[25],clk,En,reset,Q[25],Qn[25]);
    D_FFEC d26(WriteData[26],clk,En,reset,Q[26],Qn[26]);
    D_FFEC d27(WriteData[27],clk,En,reset,Q[27],Qn[27]);
    D_FFEC d28(WriteData[28],clk,En,reset,Q[28],Qn[28]);
    D_FFEC d29(WriteData[29],clk,En,reset,Q[29],Qn[29]);
    D_FFEC d30(WriteData[30],clk,En,reset,Q[30],Qn[30]);
    D_FFEC d31(WriteData[31],clk,En,reset,Q[31],Qn[31]);
endmodule

//寄存器
module REG32(WriteData,En,clk,reset,Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0);
    input[31:0]WriteData,En;
    input clk,reset;
    output[31:0]Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0;
    wire [31:0]Qn31,Qn30,Qn29,Qn28,Qn27,Qn26,Qn25,Qn24,Qn23,Qn22,Qn21,Qn20,Qn19,Qn18,Qn17,Qn16,Qn15,Qn14,Qn13,Qn12,Qn11,Qn10,Qn9,Qn8,Qn7,Qn6,Qn5,Qn4,Qn3,Qn2,Qn1,Qn0;
    D_FFEC32 q31(WriteData,clk,En[31],reset,Q31,Qn31);
    D_FFEC32 q30(WriteData,clk,En[30],reset,Q30,Qn30);
    D_FFEC32 q29(WriteData,clk,En[29],reset,Q29,Qn29);
    D_FFEC32 q28(WriteData,clk,En[28],reset,Q28,Qn28);
    D_FFEC32 q27(WriteData,clk,En[27],reset,Q27,Qn27);
    D_FFEC32 q26(WriteData,clk,En[26],reset,Q26,Qn26);
    D_FFEC32 q25(WriteData,clk,En[25],reset,Q25,Qn25);
    D_FFEC32 q24(WriteData,clk,En[24],reset,Q24,Qn24);
    D_FFEC32 q23(WriteData,clk,En[23],reset,Q23,Qn23);
    D_FFEC32 q22(WriteData,clk,En[22],reset,Q22,Qn22);
    D_FFEC32 q21(WriteData,clk,En[21],reset,Q21,Qn21);
    D_FFEC32 q20(WriteData,clk,En[20],reset,Q20,Qn20);
    D_FFEC32 q19(WriteData,clk,En[19],reset,Q19,Qn19);
    D_FFEC32 q18(WriteData,clk,En[18],reset,Q18,Qn18);
    D_FFEC32 q17(WriteData,clk,En[17],reset,Q17,Qn17);
    D_FFEC32 q16(WriteData,clk,En[16],reset,Q16,Qn16);
    D_FFEC32 q15(WriteData,clk,En[15],reset,Q15,Qn15);
    D_FFEC32 q14(WriteData,clk,En[14],reset,Q14,Qn14);
    D_FFEC32 q13(WriteData,clk,En[13],reset,Q13,Qn13);
    D_FFEC32 q12(WriteData,clk,En[12],reset,Q12,Qn12);
    D_FFEC32 q11(WriteData,clk,En[11],reset,Q11,Qn11);
    D_FFEC32 q10(WriteData,clk,En[10],reset,Q10,Qn10);
    D_FFEC32 q9(WriteData,clk,En[9],reset,Q9,Qn9);
    D_FFEC32 q8(WriteData,clk,En[8],reset,Q8,Qn8);
    D_FFEC32 q7(WriteData,clk,En[7],reset,Q7,Qn7);
    D_FFEC32 q6(WriteData,clk,En[6],reset,Q6,Qn6);
    D_FFEC32 q5(WriteData,clk,En[5],reset,Q5,Qn5);
    D_FFEC32 q4(WriteData,clk,En[4],reset,Q4,Qn4);
    D_FFEC32 q3(WriteData,clk,En[3],reset,Q3,Qn3);
    D_FFEC32 q2(WriteData,clk,En[2],reset,Q2,Qn2);
    D_FFEC32 q1(WriteData,clk,En[1],reset,Q1,Qn1);
    assign Q0=0;//寄存器堆的规定：0号寄存器的值必须是0。
    assign Qn0=0;
endmodule

module MUX32X32(Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0,S,RegAddr);
    input [31:0]Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0;
    input [4:0]S;
    output [31:0]RegAddr;
    function [31:0]select;
        input [31:0]Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0;
        input [4:0]S;
            case(S)
                5'b00000:select=Q0;
                5'b00001:select=Q1;
                5'b00010:select=Q2;
                5'b00011:select=Q3;
                5'b00100:select=Q4;
                5'b00101:select=Q5;
                5'b00110:select=Q6;
                5'b00111:select=Q7;
                5'b01000:select=Q8;
                5'b01001:select=Q9;
                5'b01010:select=Q10;
                5'b01011:select=Q11;
                5'b01100:select=Q12;
                5'b01101:select=Q13;
                5'b01110:select=Q14;
                5'b01111:select=Q15;
                5'b10000:select=Q16;
                5'b10001:select=Q17;
                5'b10010:select=Q18;
                5'b10011:select=Q19;
                5'b10100:select=Q20;
                5'b10101:select=Q21;
                5'b10110:select=Q22;
                5'b10111:select=Q23;
                5'b11000:select=Q24;
                5'b11001:select=Q25;
                5'b11010:select=Q26;
                5'b11011:select=Q27;
                5'b11100:select=Q28;
                5'b11101:select=Q29;
                5'b11110:select=Q30;
                5'b11111:select=Q31;
            endcase
    endfunction
    assign RegAddr = select(Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0,S);    
endmodule

//寄存器堆实现
module Registers(ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,clk,reset,Read1,Read2);
    input [4:0]ReadReg1,ReadReg2,WriteReg;
    input [31:0]WriteData;
    input RegWrite,clk,reset;//RegWrite:寄存器写使能信号     clk:时钟信号    reset：异步复位信号
    output [31:0]Read1,Read2;//根据寄存器编号得到寄存器地址，最终从寄存器堆读取出的寄存器数据
    
    //写寄存器，译码过程根据WriteReg得到写寄存器编号位置
    wire [31:0]RegAddr;
    DEC5T32E dec(WriteReg,RegWrite,RegAddr);
    
    wire [31:0]Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0;
    //寄存器写入数据过程，收到使能信号和复位信号的控制，这里的使能信号也就是上面的寄存器编号位置决定。
    //32个寄存器，最多只允许一个寄存器写入数据，也就是RegAddr最多有1位是1，其他均是0。
    REG32 reg32(WriteData,RegAddr,clk,reset,Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0);
    
    //读寄存器，根据5位ReadReg得到读寄存器
    MUX32X32 select1(Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0,ReadReg1,Read1);
    MUX32X32 select2(Q31,Q30,Q29,Q28,Q27,Q26,Q25,Q24,Q23,Q22,Q21,Q20,Q19,Q18,Q17,Q16,Q15,Q14,Q13,Q12,Q11,Q10,Q9,Q8,Q7,Q6,Q5,Q4,Q3,Q2,Q1,Q0,ReadReg2,Read2);
endmodule
