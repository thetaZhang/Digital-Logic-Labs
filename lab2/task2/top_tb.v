`timescale 1ns/100ps
module top_tb;
    // 端口信号
    reg clk,rst_n,data_in;
    wire [2:0] data_out;

    // 移位寄存器当前状态数据 
    reg  [15:0] data_reg;

    // 循环索引
    integer i;

    // 实例化顶层模块
    top u1(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out)
    );


    initial begin
        clk = 0; // 时钟初始化
        rst_n = 1; 
        data_in = 0; // 输入信号初始化
        #20 rst_n = 0; // 初始复位
        #20 rst_n = 1;
        for (i=0; i<=2000; i=i+1) begin // 循环2000次，实现2000个数检测
            // 生成10ns周期时钟，同时在每个上升沿前1ns改变输入信号
            #4 data_in = {$random}%(2'd2); // 输入0/1随机值
            #1 clk = ~clk; // 上升沿
            if (data_out != (data_reg % 3'd7)) // 对比当前输出和寄存器值运算的出的余数，若不符则输出错误信息
                // 出现错误时打印当前输出、寄存器值和序号 
                $display("Error: data_out = %d, data_reg = %d,i = %d",data_out,data_reg,i);
            #5 clk = ~clk; // 下降沿
        end

        $finish;
    end

    //由于寄存器数据不是模块的输出端口，在testbench中不能直接调用
    //故需模拟一个同样的寄存器来判断结果是否正确
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) 
            data_reg <= 16'b0;
        else 
            data_reg <= {data_reg[14:0],data_in};
    end


endmodule