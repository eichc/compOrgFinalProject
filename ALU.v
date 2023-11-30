module ALU (ac, mbr, clk, control);
input clk;
input [15:0] ac;
input [2:0] control
inout reg [15:0] mbr;

always @(posedge clk) begin
    case (control)
        3'b000: ac <= ac + mbr;
        3'b001: ac <= ac - mbr;
        3'b010: ac <= ac & mbr;
        3'b011: ac <= ac | mbr;
        3'b100: ac <= ~ac;
    endcase
end



endmodule