  module Top;
    bit clk;
    bit rst;
    always #5 clk = ~clk;

    initial begin
      clk = 0;
      rst = 1;
      #20
      rst = 0;
    end


    Microprocessor_intf intf(clk, rst);
    Microprocessor_TB   tb(intf);
    Microprocessor      dut(.clk(clk),
                            .rst(rst),
                            .instructions(intf.instructions),
                            .result(intf.result),
                            .zero_flag(intf.zero_flag),
                            .overflow_flag(intf.overflow_flag),
                			.pc(intf.pc));  
  endmodule