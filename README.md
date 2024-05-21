# SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification
Simple five operations microprocessor design and verification project. The code is written in SystemVerilog for design files and test bench. Synopsys VCS tool is used for generating the verification coverage reports.

## Design Specifications
-	8-bit microprocessor.
-	Five operations: Two arithmetic operations (ADD, SUB), Two logic operations (AND, OR) and JUMP operation.
-	Outputs: 8-bit result, zero flag and overflow flag.

## Block Diagram
![Block Diagram](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/Block%20Diagram.png)

## Components
![Components](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/Components.png)

## Opcode and Instruction
![opcode](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/opcode.png)

## Testing Architecture
![Testing Architecture](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/Testing%20Architecture.png)

## Testbench
The testcbench is composed of 4 classes:
#### 1- Instructions Randomization Constraints Class:
This class is responsible for randomizing the 32-bit instruction with constraints to cover different values necessary for the testing process.

Instruction Constraints:
-	The opcode bits should be generated with probabilities:
 50% for “ADD” and “SUB” operations, 50% for “AND” and “OR” operations.
-	In case of “SUB A, B” operation, B should be smaller than or equal to A because it is an unsigned operation.
-	Unused bits in the instruction should be set to 0. 

#### 2- Generator Class:
This class is responsible for generating random instructions to fill up the instruction set memory.

#### 3- Golden Reference Class:
This class is responsible for calculating the expected outputs based on the executed instruction at a given time cycle.

#### 4- Scoreboard Class:
This class is responsible for comparing the expected output with the DUT output and displays the test case result either passed or failed.

## Testbench Results

Randomized Instruction Memory
![Testbench Results](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/Instruction%20Memory.png)

At each time cycle:
-	in case of non-jump operations, the program counter is incremented by 4 as each instruction occupies four bytes in the memory.
-	one instruction is fetched, another instruction is executed.
-	any instruction takes 2 Cycles to be executed.
-	The expected output is compared with the DUT output and the test case is stated either passed or failed.

Here’s a sample of the testing results after testbench compilation and run.

![Testbench Results](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/result1.png)
![Testbench Results](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/result2.png)

## Synopsys VCS tool Coverage Report Summary
![Synopsys VCS Coverage Report Summary](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/Synopsys%20Result.png)
![Synopsys VCS Coverage Report Summary](https://github.com/AlyNasr/SystemVerilog-Project-Simple-Microprocessor-Design-and-Verification/blob/main/images/synopsys2.png)

##### *Note: To see the full details for the coverage report, downloa the folder "Synopsys VCS Coverage Report" and open the html files in a web browser.     
