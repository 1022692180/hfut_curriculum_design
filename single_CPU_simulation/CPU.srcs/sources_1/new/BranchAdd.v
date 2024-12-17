module BranchAdd(
    input [31:0]PC,
    input [31:0]imm,
    output [31:0]branch_addr
    );
    
    wire Cin,Cout;
  
    assign Cin = 1'b0;
 
    AS_32 BranchAdd32(PC, imm, Cin, branch_addr, Cout);
endmodule
