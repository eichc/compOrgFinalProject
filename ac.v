module AC (in, clk, reset, acc);
    input [15:0] in;
    input clk, reset;
    reg [15:0] acc;
    always @(clk) begin
        if (reset)
            acc <= 8'b0000000000000000;
        else
            acc <= acc + in;
    end
endmodule