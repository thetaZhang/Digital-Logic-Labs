module control(
  input clk_100hz,
  input rst_n,
  input sw_en,
  input pause,
  input clear,
  output reg time_sec_h[2:0],
  output reg time_sec_l[3:0],
  output reg time_msec_h[3:0],
  output reg time_msec_l[3:0],
  output time_out
  
);


 // 存储内部真实计时
reg [2:0] time_sec_h_reg;
reg [3:0] time_sec_l_reg,time_msec_h_reg,time_msec_l_reg;

always @(posedge clk_100hz or negedge rst_n) 
  if (~rst_n || clear) 
    time_msec_l_reg <= 4'b0;
  else if (sw_en) 
    time_msec_l_reg <= (time_msec_l_reg==4'd9) ? 4'd0 : time_msec_l_reg + 1;
  else 
    time_msec_l_reg <= time_msec_l_reg;

always @(posedge clk_100hz or negedge rst_n) 
  if (~rst_n || clear) 
    time_msec_h_reg <= 4'b0;
  else if (sw_en && time_msec_l_reg == 4'd9) 
    time_msec_h_reg <= (time_msec_h_reg==4'd9) ? 4'd0 : time_msec_h_reg + 1;
  else 
    time_msec_h_reg <= time_msec_h_reg;

always @(posedge clk_100hz or negedge rst_n) 
  if (~rst_n || clear) 
    time_sec_l_reg <= 4'b0;
  else if (sw_en && time_msec_h_reg == 4'd9) 
    time_sec_l_reg <= (time_sec_l_reg==4'd9) ? 4'd0 : time_sec_l_reg + 1;
  else 
    time_sec_l_reg <= time_sec_l_reg;

always @(posedge clk_100hz or negedge rst_n) 
  if (~rst_n || clear) 
    time_sec_h_reg <= 3'b0;
  else if (sw_en && time_sec_l_reg == 4'd9) 
    time_sec_h_reg <= (time_sec_h_reg==3'd5) ? 3'd0 : time_sec_h_reg + 1;
  else 
    time_sec_h_reg <= time_sec_h_reg;




always @(posedge clk_100hz or negedge rst_n)
  if (~rst_n || clear)
    time_msec_l <= 4'b0;
  else if (pause)
    time_msec_l <= time_msec_l;
  else 
    time_msec_l <= time_msec_l_reg;
  
always @(posedge clk_100hz or negedge rst_n)
  if (~rst_n || clear)
    time_msec_h <= 4'b0;
  else if (pause)
    time_msec_h <= time_msec_h;
  else 
    time_msec_h <= time_msec_h_reg;


endmodule
