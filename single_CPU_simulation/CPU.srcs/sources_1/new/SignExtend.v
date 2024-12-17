module SignExtend(X,Se,Y);
    input [15:0]X;
    input Se;
    output [31:0]Y;
    wire [31:0]E0,E1;
    assign E0={16'b0000000000000000, X};
    assign E1={{16{X[15]}}, X};
    MUX2X32 i(E0,E1,Se,Y);
endmodule
