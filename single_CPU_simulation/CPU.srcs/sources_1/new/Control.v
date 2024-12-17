module Control(
     input [5:0]op,//指令[31:26]的操作码
     input [5:0]func,//R型指令[5:0]的功能码
     input clk,
     input reset,
     output reg [1:0]RegDst, 
     output reg Branch, MemRead, 
     output reg [1:0]MemToReg, 
     output reg[3:0]Aluc,
     output reg Memwrite, ALUSrc1, ALUSrc2, RegWrite,Jump,Se,JR
 );
 
 reg [2:0]i_state, o_state;
 reg [2:0]next_state;
 
 parameter [2:0]    IF = 3'b000, // IF状态
                     ID = 3'b001, // ID状态
                     EXE_1 = 3'b110, // 第一支路的EXE状态:需要写回（寄存器操作）
                     EXE_2 = 3'b101, // 第二支路的EXE状态：不需要写回
                     EXE_3 = 3'b010, // 第三支路的EXE状态：需要访存（lw sw）
                     MEM = 3'b011, // MEM状态
                     WB_1 = 3'b111, // 第一支路的WB状态：
                     WB_2 = 3'b100; // 第三支路的WB状态：
                     
   always @(posedge clk or negedge reset) begin
        if (~reset) o_state = 3'b000;
        else o_state = i_state;
   end
   always @(i_state or op) begin
        case (i_state)
            IF: next_state = ID;
            ID: begin
                if(op == 6'b000100|6'b000101) 
                    next_state = EXE_2; // beq、bne指令
                else if(op == 6'b100011|6'b101011)
                    next_state = EXE_3; // lw、sw指令
                else if(op == 6'b000010|6'b000011) 
                    next_state = IF; // j, jal, jr指令
                else next_state = EXE_1; // add, sub等指令
            end
            EXE_1: next_state = WB_1;
            EXE_2: next_state = IF;
            EXE_3: next_state = MEM;
            MEM: begin
                if (op == 6'b100011) 
                    next_state = WB_2; // lw指令
                else next_state = IF; // sw指令
            end
            WB_1: next_state = IF;
            WB_2: next_state = IF;
            default: next_state = IF;
        endcase
    end 
   
  always @(op or func) begin
    case (op)
        6'b000000: begin // R型指令
            if(func != 6'b001000)begin
                RegDst = 2'b01;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
                Branch = 1'b0;   //跳转指令。
                MemRead = 1'b0;  //内存读使能信号。
                MemToReg = 2'b00;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效。
                Memwrite = 1'b0; //内存写使能信号。
                ALUSrc2 = 1'b0;  //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
                RegWrite = 1'b1; //寄存器写使能信号。
                Jump = 1'b1;     //判断是否是J型指令，低电平有效。
                Se = 1'bx;       //0表示无符号扩展，1表示有符号扩展。
                JR = 1'b0;      //判断是否是JR指令。
            end
            else begin  //JR指令
                RegDst = 2'b11;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
                Branch = 1'b0;   //跳转指令。
                MemRead = 1'b0;  //内存读使能信号。
                MemToReg = 2'b11;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
                Memwrite = 1'b0; //内存写使能信号。
                Aluc = 4'bxxxx;//无效
                ALUSrc1 = 1'bx;
                ALUSrc2 = 1'bx;  //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
                RegWrite = 1'b0; //寄存器写使能信号。
                Jump = 1'b1;     //判断是否是J型指令，低电平有效。
                Se = 1'bx;       //0表示无符号扩展，1表示有符号扩展。
                JR = 1'b1;      //判断是否是JR指令。
            end
            case(func)  //具体判断需要进行的运算
                6'b100000: begin 
                    Aluc = 4'b0000;
                    ALUSrc1 = 1'b0;//add
                end
                6'b100010:begin 
                    Aluc = 4'b0001;//sub
                    ALUSrc1 = 1'b0;
                end
                6'b100100: begin 
                    Aluc = 4'b0010;//and
                    ALUSrc1 = 1'b0;
                end
                6'b100101: begin 
                    Aluc = 4'b0011;//or
                    ALUSrc1 = 1'b0;
                end 
                6'b100110: begin 
                    Aluc = 4'b0100;//xor
                    ALUSrc1 = 1'b0;
                end 
                6'b100111: begin 
                    Aluc = 4'b0101;//nor
                    ALUSrc1 = 1'b0;
                end
                6'b000000: begin 
                    Aluc = 4'b0110;//sll
                    ALUSrc1 = 1'b1;
                end
                6'b000010: begin 
                    Aluc = 4'b0111;//srl
                    ALUSrc1 = 1'b1;
                end
                6'b000011: begin 
                    Aluc = 4'b1001;//sra
                    ALUSrc1 = 1'b1;
                end
                default:begin
                    Aluc = 4'bxxxx;//无效
                    ALUSrc1 = 1'bx;
                end
            endcase
        end
        6'b001000:begin //addi指令
            RegDst = 2'b00;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b00;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0000;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;  //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b1;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b001100:begin //andi指令
            RegDst = 2'b00;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b00;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0010;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b1;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b001101:begin //ori指令
            RegDst = 2'b00;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b00;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0011;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b1;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b001110:begin //xori指令
            RegDst = 2'b00;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b00;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0100;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b1;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b100011:begin //lw指令
            RegDst = 2'b00;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b1;  //内存读使能信号。
            MemToReg = 2'b01;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0000;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b0;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b101011:begin //sw指令
            RegDst = 2'b11;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b1;  //内存读使能信号。
            MemToReg = 2'b11;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0000;
            Memwrite = 1'b1; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b0; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b0;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b000100:begin //beq指令
            RegDst = 2'b11;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b1;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b11;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0001;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b0;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b0; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b0;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b000101:begin //bne指令
            RegDst = 2'b11;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b1;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b11;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b0001;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b0;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b0; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b0;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b001111:begin //lui指令
            RegDst = 2'b00;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b00;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'b1000;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'b0;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'b1;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令，低电平有效。
            Se = 1'b0;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b000010:begin //J指令
            RegDst = 2'b11;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b11;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'bxxxx;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'bx;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'bx;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b0; //寄存器写使能信号。
            Jump = 1'b0;     //判断是否是J型指令。
            Se = 1'b0;          //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        6'b000011:begin //Jal指令
            RegDst = 2'b10;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b10;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'bxxxx;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'bx;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'bx;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b1; //寄存器写使能信号。
            Jump = 1'b0;     //判断是否是J型指令。
            Se = 1'b0;       //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
        default:begin
            RegDst = 2'b11;   //写回阶段，00表示写回rt寄存器，01表示rd寄存器，10表示31号寄存器，11表示无效。
            Branch = 1'b0;   //跳转指令。
            MemRead = 1'b0;  //内存读使能信号。
            MemToReg = 2'b11;//写入寄存器的数据来源。00表示ALU，01表示内存，10表示PC+4，11表示无效.
            Aluc = 4'bxxxx;
            Memwrite = 1'b0; //内存写使能信号。
            ALUSrc1 = 1'bx;  //ALU的第一个算子来源。0表示rs，1表示移位寄存器sa。
            ALUSrc2 = 1'bx;   //ALU的第二个算子的来源，0表示rt，1表示扩展后的32位立即数。
            RegWrite = 1'b0; //寄存器写使能信号。
            Jump = 1'b1;     //判断是否是J型指令。
            Se = 1'bx;       //0表示无符号扩展，1表示有符号扩展。
            JR = 1'b0;      //判断是否是JR指令。
        end
    endcase
end
endmodule
