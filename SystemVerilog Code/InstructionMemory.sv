module InstructionMemory #(parameter 
                             ADDR_WIDTH = 6,
                             DATA_WIDTH = 8,
                             MEM_SIZE = 2**ADDR_WIDTH)(
      input clk,
      input rst,
      input  [ADDR_WIDTH-1:0] address,
      input  [DATA_WIDTH-1:0] instructions [0:MEM_SIZE-1],
      output logic [2:0] opcode,
      output logic [DATA_WIDTH-1:0] data_A,
      output logic [DATA_WIDTH-1:0] data_B
  );

  logic [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];


  always_ff @(posedge clk) begin
      if (rst) begin
        for(int i = 0; i < MEM_SIZE; i = i + 1) begin
          memory[i] <= instructions[i]; 
        end
      end

      opcode <= memory[address][2:0];
      data_A <= memory[address + 1];
      data_B <= memory[address + 2];
  end
  endmodule