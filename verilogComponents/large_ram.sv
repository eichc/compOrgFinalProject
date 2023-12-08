`include "ram.sv"
`include "decoder.sv"

`timescale 1 ns / 1 ps

module large_ram
  # ( parameter ADDR_WIDTH = 12,
      parameter DATA_WIDTH = 16,
      parameter DATA_WIDTH_SHIFT = 1
    )
  
  (   input clk,
      input [ADDR_WIDTH-1:0] addr,
      inout [DATA_WIDTH-1:0] data,
      input chip_select_in,
      input write_enable,
      input output_enable
  );
  
  wire [3:0] chip_select;
  
  decoder #(.ENCODE_WIDTH(2)) dec //determine which 2 chips should be activated
  (   .in(addr[ADDR_WIDTH-1:ADDR_WIDTH-2]),
      .out(chip_select) 
  );
  
  //these 8 chips work in pairs, each storing half of the 16-bit data
  single_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u00
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .chip_select(chip_select[0]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );
  single_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u01
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .chip_select(chip_select[0]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );

  single_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u10
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .chip_select(chip_select[1]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );
  single_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u11
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .chip_select(chip_select[1]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );

  single_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u20
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .chip_select(chip_select[2]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );
  single_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u21
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .chip_select(chip_select[2]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );

  single_ram  #(.DATA_WIDTH(DATA_WIDTH/2)) u30
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[(DATA_WIDTH>>DATA_WIDTH_SHIFT)-1:0]),
      .chip_select(chip_select[3]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );
  single_ram #(.DATA_WIDTH(DATA_WIDTH>>DATA_WIDTH_SHIFT)) u31
  (   .clk(clk),
      .addr(addr[ADDR_WIDTH-3:0]),
      .data(data[DATA_WIDTH-1:DATA_WIDTH>>DATA_WIDTH_SHIFT]),
      .chip_select(chip_select[3]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );

endmodule
