module test();
    reg clk,Reset;
    wire [31:0] result;
    
    top u(clk,Reset,result);

    initial begin    
	   clk = 0;
	   Reset = 0;
       #5   Reset <= 1;
    end
    
    always #5 clk = ~clk;
 endmodule
