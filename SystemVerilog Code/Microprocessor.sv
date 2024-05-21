  module Microprocessor #(parameter 
                          ADDR_WIDTH = 6,
                          DATA_WIDTH = 8,
                          MEM_SIZE = 2**ADDR_WIDTH)(
      input clk,
      input rst,
      input  [DATA_WIDTH-1:0] instructions [0:MEM_SIZE-1],
      output logic [DATA_WIDTH-1:0] result,
      output logic zero_flag,
      output logic overflow_flag,
      output logic [ADDR_WIDTH-1:0] pc	
  );

  parameter jump_opcode = 3'b100;

  wire [ADDR_WIDTH-1:0] pc_wire;
  wire [DATA_WIDTH-1:0] data_A_mem, data_B_mem, data_A_reg, data_B_reg;
  wire [DATA_WIDTH-1:0] alu_result;
  wire alu_op_wire, jmp_op_wire, zero_flag_wire, overflow_flag_wire;
  wire [2:0] opcode_wire;
  wire [1:0] op_control_wire;

  PC Pc(
      .clk(clk),
      .rst(rst), 
      .jmp(jmp_op_wire), 
      .jmp_address(data_A_reg[ADDR_WIDTH-1:0]), 
      .PC_out(pc_wire)
  );

  InstructionMemory mem(
      .clk(clk),
      .rst(rst),
      .address(pc_wire),
          .instructions(instructions),
      .opcode(opcode_wire),
      .data_A(data_A_mem),
      .data_B(data_B_mem)
  );

  RegisterFile rf(
          .clk(clk),
          .rst(rst),
      .data_in_A(data_A_mem),
      .data_in_B(data_B_mem),
      .data_out_A(data_A_reg),
      .data_out_B(data_B_reg)
  );

  ALU alu (
      .a(data_A_reg),
          .b(data_B_reg),
          .opcode(op_control_wire),
      .enable(alu_op_wire),
          .out(alu_result),
          .zero_flag(zero_flag_wire),
          .overflow_flag(overflow_flag_wire)
  );

  ControlUnit cu(
          .clk(clk),
          .rst(rst),
          .opcode(opcode_wire),
          .jmp_op(jmp_op_wire),
      .alu_op(alu_op_wire),
      .op(op_control_wire)
  );

  assign result = alu_result;
  assign zero_flag = zero_flag_wire;
  assign overflow_flag = overflow_flag_wire;
  assign pc = pc_wire;

  assert property (
    @(posedge clk) disable iff (!rst)
    (opcode_wire == jump_opcode) |-> ( pc_wire == data_A_reg)
  ) else $error("JUMP operation failed");

  assert property (
    @(posedge clk) disable iff (!rst)
    (pc_wire >= 2**ADDR_WIDTH) |-> (pc_wire == 0)
  ) else $error("Error! PC value exceeded the last memory location");

  endmodule
