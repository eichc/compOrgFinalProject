module regFile();
    logic [7:0] register[7:0];
    always @(posedge clk) begin
        read1 <= reg[addr1];
        read2 <= reg[addr2];
        if (write) begin
            register[writeAddr] <= writeData;
            if (addr1 == writeAddr)
                read1 <= writeData;
            if (addr2 == writeAddr)
                read2 <= writeData;
        end
    end
endmodule