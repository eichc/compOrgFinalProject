module AC (in, clk, reset, acc);
    input [15:0] in;
    input clk, reset;
    reg [15:0] acc;
    always @(posedge clk) begin
        if (reset)
            acc <= 16'b0000000000000000;
        else
            acc <= acc + in;
    end
endmodule