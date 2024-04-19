module counter#(
    parameter THRESHOLD = 100
)
(
    input wire clk,
    input   rst_n,  //input不能是reg
    output reg out_en  //always里赋值要reg
);

    localparam LOG_THRESHOLD = $clog2(THRESHOLD);

    reg [LOG_THRESHOLD - 1 : 0] counter;

    always @(posedge clk or negedge rst_n) //敏感信号列表添加复位信号
    begin
        if(rst_n) //分支条件应该为复位
            counter <= counter + 1; //时序逻辑，非阻塞赋值
        else
            counter <= 1'b0; // Reset value when threshold reached
    end

    always@(counter) begin
    if(counter == THRESHOLD - 1) //判断相等用==
        out_en <= 1'b1;
    else 
        out_en <= 1'b0; //写明所有分支 

    end


endmodule //必须有endmodule

