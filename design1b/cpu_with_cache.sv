`include "large_ram.sv"
`include "alu.sv"
`include "cache.sv"
`timescale 1 ns / 1 ps

module indirect_cpu;
  parameter ADDR_WIDTH = 12;
  parameter DATA_WIDTH = 16;
  
  reg osc;
  localparam period = 10;

  wire clk; 
  assign clk = osc; 

  reg chip_select;
  reg write_enable;
  reg output_enable;
  integer i;
  reg [ADDR_WIDTH-1:0] MAR;
  wire [DATA_WIDTH-1:0] data;
  reg [DATA_WIDTH-1:0] testbench_data;
  assign data = !output_enable ? testbench_data : 'hz;
  
  cache #(.DATA_WIDTH(DATA_WIDTH)) myCache
  (   .clk(clk),
      .addr(MAR),
      .data(data[DATA_WIDTH-1:0]),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );

  large_ram  #(.DATA_WIDTH(DATA_WIDTH)) ram
  (   .clk(clk),
   .addr(MAR),
      .data(data[DATA_WIDTH-1:0]),
      .chip_select_in(chip_select),
      .write_enable(write_enable),
      .output_enable(output_enable)
  );
  
  reg [15:0] A;
  reg [15:0] B;
  reg [15:0] ALU_Out;
  reg [2:0] ALU_Sel;
  alu my_alu(
    .A(A),
    .B(B),  // ALU 16-bit Inputs
    .ALU_Sel(ALU_Sel),// ALU Selection
    .ALU_Out(ALU_Out) // ALU 16-bit Output
     );
  
  reg [15:0] PC = 'h100;
  reg [15:0] IR = 'h0;
  reg [15:0] MBR = 'h0;
  reg [15:0] AC = 'h0;

  initial osc = 1;  //init clk = 1 for positive-edge triggered
  always begin  // Clock wave
     #period  osc = ~osc;
  end

  initial begin
   
     $dumpfile("dump.vcd");
     $dumpvars;
    // Fibonacci
    @(posedge clk) MAR <= 'h100; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h111C;
    @(posedge clk) MAR <= 'h102; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h711A;
    @(posedge clk) MAR <= 'h104; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h211E;
    @(posedge clk) MAR <= 'h106; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h111C;
    @(posedge clk) MAR <= 'h108; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h211A;
    @(posedge clk) MAR <= 'h10A; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h111E;
    @(posedge clk) MAR <= 'h10C; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h211C;
    @(posedge clk) MAR <= 'h10E; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h1120;
    @(posedge clk) MAR <= 'h110; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h7122;
    @(posedge clk) MAR <= 'h112; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h2120;
    @(posedge clk) MAR <= 'h114; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h4001;
    @(posedge clk) MAR <= 'h116; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h5100;
    @(posedge clk) MAR <= 'h118; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h6000;
    @(posedge clk) MAR <= 'h11A; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h0001;
    @(posedge clk) MAR <= 'h11C; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h0001;
    @(posedge clk) MAR <= 'h11E; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h0000;
    @(posedge clk) MAR <= 'h120; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h1001;
    @(posedge clk) MAR <= 'h122; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'hFFFF;
    @(posedge clk) MAR <= 'h124; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h011A;
    @(posedge clk) MAR <= 'h126; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h011C;
    @(posedge clk) MAR <= 'h128; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h011E;
    @(posedge clk) MAR <= 'h12A; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h0120;
    @(posedge clk) MAR <= 'h12C; write_enable <= 1; chip_select <= 1; output_enable <= 0; testbench_data <= 'h0122;
    
    
    @(posedge clk) PC <= 'h100;
    
    for (i = 0; i < 62; i = i+1) begin
          // Fetch
          @(posedge clk) MAR <= PC; write_enable <= 0; chip_select <= 1; output_enable <= 1;
          @(posedge clk) IR <= data;
          @(posedge clk) PC <= PC + 2;
          // Decode and execute
      case(IR[15:12])
        4'b0001: begin //load
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) AC <= MBR;
        end 
		4'b0010: begin //store
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= AC;
              @(posedge clk) write_enable <= 1; output_enable <= 0; testbench_data <= MBR;      
        end
        4'b0011: begin //clear
          @(posedge clk) AC <= 0;
        end
        4'b0100: begin //skip
          @(posedge clk)
          if(IR[1:0]==2'b01 && AC == 0) PC <= PC + 2;
          else if(IR[1:0]==2'b00 && AC < 0) PC <= PC + 2;
          else if(IR[1:0]==2'b10 && AC > 0) PC <= PC + 2;
        end
        4'b0101: begin //jump
              @(posedge clk) PC <= IR[11:0];
        end
        4'b0110: begin //halt
              @(posedge clk) PC <= PC - 2;
        end 
        4'b0111: begin //add
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b000; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1000: begin //subtract
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b001; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1001: begin //and
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b010; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1010: begin //or
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b011; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1011: begin //not
              @(posedge clk) ALU_Sel <= 'b100; A <= AC; B <= 'b0;
              @(posedge clk) AC <= ALU_Out;
        end       
        4'b1100: begin //load indirect
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) MAR <= MBR;
              @(posedge clk) MBR <= data;
              @(posedge clk) AC <= MBR;
        end 
        4'b1101: begin //store indirect
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) MAR <= MBR;
              @(posedge clk) MBR <= AC;
              @(posedge clk) write_enable <= 1; output_enable <= 0; testbench_data <= MBR;      
        end
        4'b1110: begin //add indirect
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) MAR <= MBR;
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b000; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
          
      endcase
         
    end
    
      
    @(posedge clk) MAR <= 'h11E; write_enable <= 0; chip_select <= 1; output_enable <= 1;
    
    @(posedge clk)
        
   #20 $finish;
  end

endmodule
