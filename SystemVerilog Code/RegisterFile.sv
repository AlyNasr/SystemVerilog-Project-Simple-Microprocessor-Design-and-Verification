 module RegisterFile #(parameter DATA_WIDTH = 8)(
      input clk,
      input rst,
      input  [DATA_WIDTH-1:0] data_in_A,
      input  [DATA_WIDTH-1:0] data_in_B,
      output [DATA_WIDTH-1:0] data_out_A,
      output [DATA_WIDTH-1:0] data_out_B
  );

  logic [DATA_WIDTH-1:0] registers [0:1];

  always_ff @(posedge clk) begin
      if (rst) begin
        for(int i = 0; i < 2; i = i + 1) begin
      		registers[i] <= 8'b0;
        end
      end else begin
      registers[0] <= data_in_A;
      registers[1] <= data_in_B;
      end
  end

  assign   data_out_A = registers[0];
  assign   data_out_B = registers[1];
  endmodule
