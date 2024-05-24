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


endmodule
