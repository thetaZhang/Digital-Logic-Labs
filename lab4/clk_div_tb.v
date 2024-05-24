module clk_div_tb ();

  reg clk, rst;
  wire clk_100, clk_25;

  clk_div DUT (
      .clk_100mhz(clk),
      .rst_n(rst),
      .clk_100hz(clk_100),
      .clk_25mhz(clk_25)
  );

  initial begin
    clk = 0;
    rst = 0;
    #25 rst = 1;
    #1000 $finish;
  end

  always #5 clk = ~clk;

endmodule
