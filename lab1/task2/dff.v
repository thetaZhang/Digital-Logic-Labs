// 1bit ff
module dff (
    input d,
    input clk,
    input rst_n,
    output reg q
);

  always @(posedge clk or negedge rst_n) begin
    q <= 0;
    if (~rst_n) q <= 1'b0;
    else q <= d;
  end

endmodule
