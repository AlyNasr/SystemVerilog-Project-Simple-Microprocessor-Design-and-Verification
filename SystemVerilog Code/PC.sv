 module PC #(parameter ADDR_WIDTH = 6)(
      input clk,
      input rst,
      input jmp,
      input [ADDR_WIDTH-1:0] jmp_address,
      output logic [ADDR_WIDTH-1:0] PC_out
  );

  always_ff @(posedge clk) begin
    if ((rst) || (PC_out >= 2**ADDR_WIDTH)) begin
      PC_out <= 0;
    end else if (jmp) begin
      PC_out <= jmp_address;
    end else begin
      PC_out <= PC_out + 4;
    end 
  end
  endmodule