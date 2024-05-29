`timescale 1ns / 1ns
;
module control_tb ();

  reg clk_reg, rst_n_reg, sw_en_reg, pause_reg, clear_reg;
  wire [2:0] sec_h;
  wire [3:0] sec_l, msec_h, msec_l;
  wire time_out;

  control DUT (
      .clk_100hz(clk_reg),
      .rst_n(rst_n_reg),
      .sw_en(sw_en_reg),
      .pause(pause_reg),
      .clear(clear_reg),
      .time_sec_h(sec_h),
      .time_sec_l(sec_l),
      .time_msec_h(msec_h),
      .time_msec_l(msec_l),
      .time_out(time_out)
  );

  always #5 clk_reg = ~clk_reg;

  initial begin
    clk_reg   = 0;
    rst_n_reg = 0;
    sw_en_reg = 0;
    pause_reg = 0;
    clear_reg = 0;

    #25 rst_n_reg = 1;
    sw_en_reg = 1;

    #100 pause_reg = 1;
    #100 pause_reg = 0;
    #100 sw_en_reg = 0;
    #100 sw_en_reg = 1;
    #100 clear_reg = 1;
    #100 clear_reg = 0;

  end

endmodule
