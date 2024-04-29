module counter #(
    parameter THRESHOLD = 100
) (
    input wire clk,
    input rst_n,  //input信号不能是reg
    output reg out_en  //always里赋值的信号应该为reg
);

  localparam LOG_THRESHOLD = $clog2(THRESHOLD);

  reg [LOG_THRESHOLD - 1 : 0] counter;

  always @(posedge clk or negedge rst_n) begin
    if (rst_n)  //应该有复位信号
      //时序逻辑应使用非阻塞赋值
      if (counter < THRESHOLD) counter <= counter + 1;  
      // counter 位数由LOG_THRESHOLD决定
      else counter <= {LOG_THRESHOLD{1'b0}};  
    else counter <= {LOG_THRESHOLD{1'b0}};  
  end

  always @(*) begin  //敏感信号列表写*以免遗漏
    if (counter == THRESHOLD - 1)  //判断相等用==
      out_en = 1'b1;//组合逻辑用阻塞赋值
    else out_en = 1'b0;  //写明所有分支
  end


endmodule  //必须有endmodule

