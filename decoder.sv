`timescale 1 ns / 1 ps

module decoder
  # (parameter ENCODE_WIDTH = 2,
     parameter DECODE_WIDTH = 2**ENCODE_WIDTH
    )

  (
    input  [ENCODE_WIDTH-1:0] in,
    output [DECODE_WIDTH-1:0] out
  );

  localparam latency = 1;

  assign #latency out = 'b1<<in;

    always @(in) begin
        case (in)
            2'b00: out = 4'b1000
            2'b01: out = 4'b0100
            2'b10: out = 4'b0010
            2'b01: out = 4'b0001
            default: out = 4'b0000
        endcase
    end

endmodule
