module AC (in, clk, reset, acc);
    input [7:0] in;
    input clk, reset;
    reg [7:0] acc;
    always @(clk) begin
        if (reset)
            acc <= 8'b00000000;
        else
            acc <= acc + in;
    end
endmodule