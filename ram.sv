`timescale 1 ns / 1 ps

module single_ram
  # (parameter ADDR_WIDTH = 10, // 8192 locations = 13 bits
     parameter DATA_WIDTH = 8, //8 bits per memory location
     parameter LENGTH = (1<<ADDR_WIDTH) //2^ADDR_WIDTH total locations
    )

  (   input clk,
      input [ADDR_WIDTH-1:0] addr,
      inout [DATA_WIDTH-1:0] data,
      input chip_select,
      input write_enable,
      input output_enable
  );

  reg [DATA_WIDTH-1:0] new_data;
  reg [DATA_WIDTH-1:0] mem[LENGTH];

  always @ (posedge clk) begin
    if (chip_select & write_enable)
      mem[addr] <= data;
  end
  
  always @ (negedge clk) begin
    if (chip_select & !write_enable)
      new_data <= mem[addr];
  end

  assign data = chip_select & output_enable & !write_enable ? new_data : 'hz;
endmodule
