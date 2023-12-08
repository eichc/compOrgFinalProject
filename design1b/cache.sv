`timescale 1 ns / 1 ps

module single_ram
  # (parameter ADDR_WIDTH = 10,
     parameter DATA_WIDTH = 16, //16 bits per memory location
     parameter LENGTH = (1<<ADDR_WIDTH), //2^ADDR_WIDTH total locations
     parameter SIZE = 2500
    )

  (   input clk,
      input [ADDR_WIDTH-1:0] addr,
      inout [DATA_WIDTH-1:0] data,
      input write_enable,
      input output_enable
  );

  reg [ADDR_WIDTH-1:0] addr_array[SIZE];
  reg [DATA_WIDTH-1:0] data_array[SIZE];
  reg [1:0] valid_array[SIZE];
  
  initial begin
    for (int i=0; i < SIZE; i=i+1) begin
      addr_array[i]=0;
      data_array[i]=0;
      valid_array[i]=0;
    end
  end

  always @(posedge clk) begin
    if (write_enable) begin
        int unused;
        for (int i=0; i<SIZE; i=i+1) begin
            if (valid_array[i]==0) begin 
                usused=i;
                break;
            end
            if (i==SIZE-1) begin
                for (int j=1; j<SIZE; j=j+1) begin
                    addr_array[j-1]=addr_array[j];
                    data_array[j-1]=data_array[j];
                    valid_array[j-1]=valid_array[j];
                end
                addr_array[i] = addr;
                data_array[i] = data;
                valid_array[i]= 1;
            end
        end
        addr_array[unused] = addr;
        data_array[unused] = data;
        valid_array[unused]= 1;
    end

    if (output_enable) begin 
        for (int i=0; i<SIZE; i=i+1) begin
            if (addr == addr_array[i]) begin
                data <= data_array[i];
            end
        end
    end
  end


endmodule
