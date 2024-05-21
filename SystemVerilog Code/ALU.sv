 module ALU #(parameter DATA_WIDTH = 8)(
    input  [DATA_WIDTH-1:0] a,
    input  [DATA_WIDTH-1:0] b,
    input  [1:0] opcode,
    input  enable,
    output logic [DATA_WIDTH-1:0] out,
    output logic zero_flag,
    output logic overflow_flag
  );
  parameter ADD = 2'b00,
       		SUB = 2'b01,
            AND = 2'b10,
            OR =  2'b11;

  logic overflow_bit;
  always_comb begin
      if(enable) begin
      case (opcode)
        ADD: {overflow_bit, out} <= a + b;
        SUB: {overflow_bit, out} <= a - b;
        AND: {overflow_bit, out} <= a & b;
        OR: {overflow_bit, out} <= a | b; 
        default: {overflow_bit, out} <= 0;
      endcase
      end
  end

  assign zero_flag = (out == 0)? 1'b1:1'b0;
  assign overflow_flag = overflow_bit;
  endmodule