`timescale 1ns / 10ps

module lab1_tb ();
  localparam CLOCK_PERIOD = 10;
  localparam COUNTER_THRESHOLD = 120;

  reg clk_reg;
  reg resetn_reg;
  wire out_en;
  reg [7:0] relu_input_data;
  wire [7:0] relu_output_data;

  always #(CLOCK_PERIOD / 2) clk_reg = ~clk_reg;

  initial begin
    clk_reg = 0;
    resetn_reg = 0;
    relu_input_data = 8'b10011010;
    #100 resetn_reg = 1;
    #2200 relu_input_data = 8'b00101110;
  end


initial begin
    $dumpfile(".\\build\\wave.vcd");
    $dumpvars(0, lab1_tb);
    #3000 $finish;
  end



  counter #(
      .THRESHOLD(COUNTER_THRESHOLD)
  ) u_counter (
      .clk   (clk_reg),
      .rst_n (resetn_reg),
      .out_en(out_en)
  );  //分号逗号用法错误

  ReLU u_relu (
      .clk        (clk_reg),
      .rst_n      (resetn_reg),
      .out_en     (out_en),
      .input_data (relu_input_data),
      .output_data(relu_output_data)
  );  // 分号逗号用法错误,模块端口和例化端口名字反了


endmodule
