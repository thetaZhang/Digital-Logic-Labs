module counter #(
    parameter THRESHOLD = 100
) (
    input wire clk,
    input rst_n,  //input不能是reg
    output reg out_en  //always里赋值要reg
);

  localparam LOG_THRESHOLD = $clog2(THRESHOLD);

  reg [LOG_THRESHOLD - 1 : 0] counter;

  always @(posedge clk or negedge rst_n) begin
    if (rst_n)  //分支条件应该为复位
      if (counter < THRESHOLD) counter <= counter + 1;  //时序逻辑，非阻塞赋值
      else counter <= {LOG_THRESHOLD{1'b0}};  // 到达上限要复位
    else counter <= {LOG_THRESHOLD{1'b0}};  // counter 位数由LOG_THRESHOLD决定
  end

  always @(*) begin  //敏感信号列表写*
    if (counter == THRESHOLD - 1)  //判断相等用==
      out_en = 1'b1;
    else out_en = 1'b0;  //写明所有分支,组合逻辑用阻塞赋值

  end


endmodule  //必须有endmodule

