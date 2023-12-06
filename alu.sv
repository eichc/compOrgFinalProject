`timescale 1ns / 1ps

module alu( input[15:0] A,B,
            input [2:0] ALU_Sel,
            output [15:0] ALU_Out
    );

    reg [15:0] ALU_Result;
    wire [15:0] tmp;
    assign ALU_Out = ALU_Result;
    always @(*)
    begin
        case(ALU_Sel)
        3'b000: //addition
            ALU_Result = A + B ; 
        3'b001: //subtraction
            ALU_Result = A - B ;
        3'b010: //AND
            ALU_Result = A & B; 
        3'b011: //OR
            ALU_Result = A | B ; 
        3'b100: //not
            ALU_Result = ~A ;
        3'b101: //clear
            ALU_Result = 0;
        default: ALU_Result = A; 
        endcase
    end


endmodule

