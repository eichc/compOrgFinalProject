`timescale 1 ns / 1 ps

module test_ram;
    parameter ADDR_WIDTH = 10;
    parameter DATA_WIDTH = 8;

    reg clk;
    reg chip_select;
    reg write_enable;
    reg output_enable;
    reg [ADDR_WIDTH-1:0] addr;
    wire [DATA_WIDTH-1:0] data;
    reg [DATA_WIDTH-1:0] testbench_data;


  single_ram #(.DATA_WIDTH(DATA_WIDTH)) u0
  (   .clk(clk),
      .addr(addr),
      .data(data),
      .chip_select(chip_select),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );

    always #20 clk = ~clk;
    assign data = !output_enable ? testbench_data : 'hz;

    integer i;
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    {clk, chip_select, write_enable, addr, testbench_data, output_enable} <= 0;

    repeat (2) @ (posedge clk);

    for (i = 0; i < 16; i = i + 1) begin
        repeat (1) @(posedge clk) addr <= i; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= $random;
    end

    for (i = 0; i < 16; i = i + 1) begin
        repeat (1) @(posedge clk) addr <= i; write_enable <= 0; chip_select <= 1; output_enable <= 1;
    end

      @(posedge clk) chip_select <=0;

    #360 $finish;

    end
endmodule