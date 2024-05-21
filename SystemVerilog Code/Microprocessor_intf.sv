  interface Microprocessor_intf #(parameter 
                              ADDR_WIDTH = 6,
                              DATA_WIDTH = 8,
                              MEM_SIZE = 2**ADDR_WIDTH)
     (input logic clk, rst);

      wire logic [DATA_WIDTH-1:0] instructions [0:MEM_SIZE-1];
      wire logic [DATA_WIDTH-1:0] result;
      logic zero_flag;
      logic overflow_flag;
      wire logic [ADDR_WIDTH-1:0] pc;

      clocking cb @ (posedge clk);
        default input #1ns output #0ns;	
        input result, zero_flag, overflow_flag, pc;
        output instructions;     
       endclocking

      modport TB(clocking cb);
    endinterface