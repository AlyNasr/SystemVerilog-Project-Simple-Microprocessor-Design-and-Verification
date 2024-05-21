 module ControlUnit (
      input clk,
      input rst,
      input [2:0] opcode,
      output logic jmp_op,
      output logic alu_op,
      output logic [1:0] op
  );

  parameter ADD = 3'b000, 
            SUB = 3'b001, 
            AND = 3'b010, 
            OR = 3'b011, 
            JUMP = 3'b100;

  always_ff @(posedge clk) begin
      if (rst) begin
        jmp_op <= 1'b0;
        alu_op <= 1'b0;
      end 

       case (opcode)
          ADD: begin 
              alu_op <= 1'b1;
          	  op <= 2'b00;
              jmp_op <= 1'b0;
          end
      SUB: begin 
              alu_op <= 1'b1;
              op <= 2'b01;
              jmp_op <= 1'b0;
          end
      AND: begin
              alu_op <= 1'b1;
              op <= 2'b10;
              jmp_op <= 1'b0;
          end
      OR: begin
              alu_op <= 1'b1;
              op <= 2'b11;
              jmp_op <= 1'b0;
          end
      JUMP: begin
              alu_op <= 1'b0;
              jmp_op <= 1'b1;
          end
      default: begin
              alu_op <= 1'b0;
              jmp_op <= 1'b0;
          end
       endcase
  end
  endmodule
