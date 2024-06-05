module control (
    input clk_100hz,
    input clk,
    input rst_n,
    input sw_en,
    input pause,
    input clear,
    output reg [2:0] time_sec_h,
    output reg [3:0] time_sec_l,
    output reg [3:0] time_msec_h,
    output reg [3:0] time_msec_l,
    output reg time_out

);

  // 存储内部真实计时
  reg [2:0] time_sec_h_reg;
  reg [3:0] time_sec_l_reg, time_msec_h_reg, time_msec_l_reg;

  // 复位信号不能与其他信号逻辑操作
  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_msec_l_reg <= 4'b0;
    else if (clear) time_msec_l_reg <= 4'b0;
    else if (sw_en) time_msec_l_reg <= (time_msec_l_reg == 4'd9) ? 4'd0 : time_msec_l_reg + 1;
    else time_msec_l_reg <= time_msec_l_reg;

  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_msec_h_reg <= 4'b0;
    else if (clear) time_msec_h_reg <= 4'b0;
    else if (sw_en && time_msec_l_reg == 4'd9)
      time_msec_h_reg <= (time_msec_h_reg == 4'd9) ? 4'd0 : time_msec_h_reg + 1;
    else time_msec_h_reg <= time_msec_h_reg;

  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_sec_l_reg <= 4'b0;
    else if (clear) time_sec_l_reg <= 4'b0;
    else if (sw_en && time_msec_h_reg == 4'd9 && time_msec_l_reg == 4'd9)
      time_sec_l_reg <= (time_sec_l_reg == 4'd9) ? 4'd0 : time_sec_l_reg + 1;
    else time_sec_l_reg <= time_sec_l_reg;

  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_sec_h_reg <= 3'b0;
    else if (clear) time_sec_h_reg <= 3'b0;
    else if (sw_en && time_sec_l_reg == 4'd9 && time_msec_h_reg == 4'd9 && time_msec_l_reg == 4'd9)
      time_sec_h_reg <= (time_sec_h_reg == 3'd5) ? 3'd0 : time_sec_h_reg + 1;
    else time_sec_h_reg <= time_sec_h_reg;



  // 时钟显示
  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_msec_l <= 4'b0;
    else if (clear) time_msec_l <= 4'b0;
    else if (pause) time_msec_l <= time_msec_l;
    else time_msec_l <= time_msec_l_reg;

  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_msec_h <= 4'b0;
    else if (clear) time_msec_h <= 4'b0;
    else if (pause) time_msec_h <= time_msec_h;
    else time_msec_h <= time_msec_h_reg;

  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_sec_l <= 4'b0;
    else if (clear) time_sec_l <= 4'b0;
    else if (pause) time_sec_l <= time_sec_l;
    else time_sec_l <= time_sec_l_reg;

  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_sec_h <= 3'b0;
    else if (clear) time_sec_h <= 3'b0;
    else if (pause) time_sec_h <= time_sec_h;
    else time_sec_h <= time_sec_h_reg;

  // time_out 信号
  always @(posedge clk_100hz or negedge rst_n)
    if (~rst_n) time_out <= 1'b0;
    else if ((time_sec_h_reg == 5 && time_sec_l_reg == 9 && time_msec_h_reg == 9 && time_msec_l_reg == 9) || clear)
      time_out <= 1'b0;
    else if (time_sec_h_reg == 1 && time_sec_l_reg == 0 && time_msec_h_reg == 0 && time_msec_l_reg == 0)
      time_out <= 1'b1;
    else time_out <= time_out;



endmodule






