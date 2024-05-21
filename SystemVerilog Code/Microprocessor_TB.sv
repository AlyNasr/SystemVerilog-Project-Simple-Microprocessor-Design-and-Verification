class Instruction_constraints #(parameter 
                                Instruction_WIDTH = 32,
                                ADDR_WIDTH = 6,
                        		DATA_WIDTH = 8,
                        		MEM_SIZE = 2**ADDR_WIDTH);
  
  rand logic [Instruction_WIDTH-1:0] rand_instruction;
  parameter ADD = 3'b000, 
  	    	SUB = 3'b001, 
            AND = 3'b010, 
            OR = 3'b011, 
            JUMP = 3'b100;
  
    constraint instruction_constr
  { 
    // opcode constraint: It should be (ADD, SUB) with 50%
    //                    and (AND, OR) with 50% 
    rand_instruction[26:24] dist {[0:1]:= 50, [2:3]:= 50};
    
    // SUB operation constraint
    // data_B should be <= data_A, because it is an unsigned operation
    if(rand_instruction[26:24] == SUB)
      rand_instruction[15:8] <= rand_instruction[23:16];
    
    // unused instruction bits are set to 0
    rand_instruction[31:27] inside {[0:0]};
    rand_instruction[7:0] inside {[0:0]};
  }  
endclass

// Class Generator for generating random instructions with constraints
class Generator #(parameter Instruction_WIDTH = 32,
                            ADDR_WIDTH = 6,
                            DATA_WIDTH = 8,
                            MEM_SIZE = 2**ADDR_WIDTH,
                 	    Num_Of_Instructions = MEM_SIZE/4);

   parameter ADD = 3'b000, 
  	     	 SUB = 3'b001, 
             AND = 3'b010, 
             OR = 3'b011, 
             JUMP = 3'b100;
  
  function void generate_random_instructions(
    input Instruction_constraints obj,
    output logic [Instruction_WIDTH-1:0] random_instructions [0:Num_Of_Instructions-1]);
    
   obj = new();
   for(int i = 0; i < Num_Of_Instructions; i = i + 1) begin
     if(i != 5) begin
      obj.randomize();
      random_instructions[i] = obj.rand_instruction;
     end else begin
    	// Jump instruction
       random_instructions[i] = 32'b0100001010000000000000000000;
     end
   end
   // Jump instruction
    random_instructions[5] = 32'b0100001010000000000000000000;
    // Insert 2 (No operation) after jump minstruction
     random_instructions[6] = 32'b1111000000000000000000000000;
     random_instructions[7] = 32'b1111000000000000000000000000;
  endfunction
  
  function void display_instruction_memory(
    input logic [Instruction_WIDTH-1:0] instructions [0:Num_Of_Instructions-1]);
    
    logic [2:0] opcode;
    logic [DATA_WIDTH-1:0] data_A;
    logic [DATA_WIDTH-1:0] data_B;
    string operation = "";
    
    integer j = 0;
    $display("\n----- Randomized Instruction Memory -----"); 
    for(int i = 0; i < Num_Of_Instructions; i = i + 1) begin
      opcode = instructions[i][26:24];
      data_A = instructions[i][23:16];
      data_B = instructions[i][15:8];
      case (opcode)
          ADD: operation = "ADD";
          SUB: operation = "SUB";
          AND: operation = "AND";
          OR: operation = "OR";
          JUMP: operation = "JUMP";
          default: operation  = "No operation";
      endcase
       
      $write("Memory address %0d:", j);
      if(operation == "JUMP")
        $display(" \"%s %0d\"", operation, data_A);
      else if(operation == "No operation")
      	$display(" %s", operation);
      else    
        $display(" \"%s %0d,%0d\"", operation, data_A, data_B);
      j += 4;
    end
    $display("\n");
  endfunction
endclass

// Class GoldenReference for calculating the expected outputs
class GoldenReference #(parameter Instruction_WIDTH = 32,
                            	  ADDR_WIDTH = 6,
                            	  DATA_WIDTH = 8,
                        	      MEM_SIZE = 2**ADDR_WIDTH,
                 		          Num_Of_Instructions = MEM_SIZE/4);
  
  parameter ADD = 3'b000, 
  	        SUB = 3'b001, 
            AND = 3'b010, 
            OR = 3'b011, 
            JUMP = 3'b100;
  
  function logic [DATA_WIDTH+1:0] calculate_expected_output(
    input  logic [Instruction_WIDTH-1:0] random_instruction, 
    output logic [DATA_WIDTH+1:0] expected_output);
  
    logic [2:0] opcode;
    logic [DATA_WIDTH-1:0] data_A;
    logic [DATA_WIDTH-1:0] data_B;
    logic zero_flag;
    logic overflow_flag;
    
    opcode = random_instruction[26:24];
    data_A = random_instruction[23:16];
    data_B = random_instruction[15:8];
      
    case (opcode)
        ADD: {overflow_flag, expected_output[DATA_WIDTH-1:0]} = data_A + data_B; 
        SUB: {overflow_flag, expected_output[DATA_WIDTH-1:0]} = data_A - data_B; 
        AND: {overflow_flag, expected_output[DATA_WIDTH-1:0]} = data_A & data_B; 
        OR:  {overflow_flag, expected_output[DATA_WIDTH-1:0]} = data_A | data_B;
        default: {overflow_flag, expected_output[DATA_WIDTH-1:0]} = 0;
    endcase
      
    zero_flag = (expected_output[DATA_WIDTH-1:0] == 0)? 1'b1:1'b0;
    expected_output[DATA_WIDTH+1] = overflow_flag;
    expected_output[DATA_WIDTH] = zero_flag;
	return expected_output;
  endfunction 
endclass

// Class Scoreboard for comparing the expected outputs with the DUT outputs
class Scoreboard #(parameter Instruction_WIDTH = 32,
                             ADDR_WIDTH = 6,
                             DATA_WIDTH = 8,
                             MEM_SIZE = 2**ADDR_WIDTH,
                 	         Num_Of_Instructions = MEM_SIZE/4);
  
   parameter ADD = 3'b000, 
             SUB = 3'b001, 
             AND = 3'b010, 
             OR = 3'b011, 
             JUMP = 3'b100;
  
  function void compare_outputs( input logic [Instruction_WIDTH-1:0] instruction,
    				 input logic [DATA_WIDTH+1:0] DUT_output,
                            	 input logic [DATA_WIDTH+1:0] expected_output);
    
    logic [2:0] opcode;
    opcode = instruction[26:24];
    
    if(opcode != JUMP) begin
    
      $display("DUT Output:       Result = %0d, Zero flag = %b, Overflow flag = %b", 	DUT_output[DATA_WIDTH-1:0], DUT_output[DATA_WIDTH], DUT_output[DATA_WIDTH+1]);
    
      $display("Expected Output:  Result = %0d, Zero flag = %b, Overflow flag = %b", expected_output[DATA_WIDTH-1:0], expected_output[DATA_WIDTH], expected_output[DATA_WIDTH+1]);
    
    	if(DUT_output == expected_output)
      		$display("Test case Passed.");
    	else
      		$display("Test case Failed.");
    end
  endfunction
endclass


module Microprocessor_TB #(parameter ADDR_WIDTH = 6, DATA_WIDTH = 8, MEM_SIZE = 2**ADDR_WIDTH) (Microprocessor_intf.TB intf);
 
  parameter	JUMP = 3'b100;
 
  covergroup cg;
   zero_flag: coverpoint intf.cb.zero_flag;
   overflow_flag: coverpoint intf.cb.overflow_flag;
  endgroup
  
  parameter Num_Of_Instructions = MEM_SIZE/4;
  parameter Instruction_WIDTH = 32;
  logic [Instruction_WIDTH-1:0] random_instructions [0:Num_Of_Instructions-1];
  logic [DATA_WIDTH+1:0] DUT_output;
  logic [DATA_WIDTH-1:0] memory_TB [0:MEM_SIZE-1];
  logic [Instruction_WIDTH-1:0] fetched_memory_instruction;
  logic [Instruction_WIDTH-1:0] executed_memory_instruction;
  integer jmp_flag = 0;
  integer jmp_time = 0;
  
  initial begin
    Instruction_constraints obj = new();
    Generator generator = new();
    generator.generate_random_instructions(obj, random_instructions);
    generator.display_instruction_memory(random_instructions);
    initialize_memory();
  end

  initial begin
    cg cov_inst = new();
    GoldenReference goldenRef = new();
    logic [DATA_WIDTH+1:0] expected_output;
    Scoreboard scoreboard = new();
    #30;
    repeat(20) begin
      DUT_output[DATA_WIDTH-1:0] = intf.cb.result;
      DUT_output[DATA_WIDTH] = intf.cb.zero_flag;
      DUT_output[DATA_WIDTH+1] = intf.cb.overflow_flag;
      
      fetched_memory_instruction = {memory_TB[intf.cb.pc], memory_TB[intf.cb.pc + 1], memory_TB[intf.cb.pc + 2], memory_TB[intf.cb.pc + 3]};
      // At a time cycle, the executed instruction is at memory location (program counter - 2) as any instruction takes 2 cycles to execute. The program counter is incremented by 4 each cycle. To get the executed instruction we have to subtract 8 (two memory locations).
   
      executed_memory_instruction = {memory_TB[intf.cb.pc - 8], memory_TB[intf.cb.pc + 1 - 8], memory_TB[intf.cb.pc + 2 - 8], memory_TB[intf.cb.pc + 3 - 8]};
      
      $display("\nTime Cycle = %0t, Program Counter = %0d", $time/10, intf.cb.pc);
      display_instruction( fetched_memory_instruction, "Fetched");
      
      if(jmp_flag != 1) begin
      display_instruction( executed_memory_instruction, "Executed");
      expected_output = goldenRef.calculate_expected_output(executed_memory_instruction, expected_output);
      scoreboard.compare_outputs(executed_memory_instruction, DUT_output, expected_output);
      end
      cov_inst.sample();
      #10;
      if(executed_memory_instruction[26:24] == JUMP) begin
        jmp_flag = 1;
        jmp_time = $time;
      end
      if($time >= jmp_time + 20) begin
      	jmp_flag = 0;
      end
      
    end
    #100 $finish; 
  end
  
  task initialize_memory();
    int j = 0;
    for(int i = 0; i < MEM_SIZE; i = i + 4) begin
      // initialize actual Microprocessor memory
      intf.cb.instructions[i] <= random_instructions[j][31:24];
      intf.cb.instructions[i+1] <= random_instructions[j][23:16];
      intf.cb.instructions[i+2] <= random_instructions[j][15:8];
      intf.cb.instructions[i+3] <= random_instructions[j][7:0];
      
      // initialize testbench memory
      memory_TB[i] <= random_instructions[j][31:24];
      memory_TB[i+1] <= random_instructions[j][23:16];
      memory_TB[i+2] <= random_instructions[j][15:8];
      memory_TB[i+3] <= random_instructions[j][7:0];
	
      j = j+1;
    end
  endtask
  
    // This function converts the 32-bit instruction to a string and display it
  function void display_instruction(input logic [Instruction_WIDTH-1:0] instruction, input string str);
    logic [2:0] opcode;
    logic [DATA_WIDTH-1:0] data_A;
    logic [DATA_WIDTH-1:0] data_B;
    string operation = "";
    parameter ADD = 3'b000, 
              SUB = 3'b001, 
              AND = 3'b010, 
              OR = 3'b011, 
              JUMP = 3'b100;
    
    opcode = instruction[26:24];
    data_A = instruction[23:16];
    data_B = instruction[15:8];
    case (opcode)
       	ADD: operation = "ADD";
       	SUB: operation = "SUB";
       	AND: operation = "AND";
       	OR: operation = "OR";
        JUMP: operation = "JUMP";
        default: operation  = "No operation";
    endcase

    if(operation == "JUMP")
      $display("%s Instruction: \"%s %0d\"", str, operation, data_A);
    else if(operation == "No operation")
      $display("%s Instruction: %s", str, operation);
    else    
      $display("%s Instruction: \"%s %0d,%0d\"", str, operation, data_A, data_B);
  endfunction
endmodule

