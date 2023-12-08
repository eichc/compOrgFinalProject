`timescale 1ns / 1ps

module testALU;

    //inputs
    reg[15:0] A,B;
    reg[2:0] ALU_Sel;

    //outputs
    wire [15:0] ALU_Out;

    integer i;
    alu test(   A,B,
                ALU_Sel,
                ALU_Out);

    initial begin
        $dumpfile("dumpfile.vcd");
        $dumpvars;

        A = 16'h0AB0;
        B = 16'h01AC;
        ALU_Sel = 3'h0;

        for (i = 0; i < 8; i=i+1) 
        begin
            ALU_Sel = ALU_Sel +  3'h1;
            #10;
        end
    end
endmodule