module clk_div (
    input rst_n,
    input clk,
    output reg clk_100hz,
    output reg clk_25mhz
);

  parameter DIV_CNT = 16'd500000;

  reg [19:0] cnt;

  always @(posedge clk or negedge rst_n)
    if (~rst_n) cnt <= 19'b0;
    else if (cnt == DIV_CNT) cnt <= 19'd1;
    else cnt <= cnt + 1'b1;

  always @(posedge clk or negedge rst_n)
    if (~rst_n) clk_100hz <= 1'b0;
    else if (cnt == DIV_CNT) clk_100hz <= ~clk_100hz;
    else clk_100hz <= clk_100hz;

  always @(posedge clk or negedge rst_n)
    if (~rst_n) clk_25mhz <= 1'b0;
    else if ((cnt[0] == 1'b0) && cnt) clk_25mhz <= ~clk_25mhz;
    else clk_25mhz <= clk_25mhz;

endmodule
