module PC(clk,Reset,Result,Address);  
    input clk;//时钟
    input Reset;//是否重置地址。0-初始化PC，否则接受新地址       
    input[31:0] Result;
    output reg[31:0] Address;
  
    always @(posedge clk or negedge Reset)//时钟上升沿传入指令
    begin  
        if (Reset == 0) //如果为0则初始化PC，否则接受新地址
            begin  
                Address <= 32'b00000000000000000000000000000000;  
            end  
        else   
            begin
                Address =  Result;
        end  
    end  
endmodule
