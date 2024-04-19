// 顶层模块

module top(
    input clk,
    input rst_n,
    output q
);

wire d1,d2,d3; //3个dff的输入,从左到右对应#1#2#3

wire q1,q2,q3; //3个dff的输出, 从左到右对应#1#2#3

assign d1 = (~q1 & q2 & q3) | (q1 & ~q2) | (q1 | ~q3);
assign d2 = (q2 ^ q3);
assign d3 = ~q3; 

assign q = ~q3; //输出

//实例化dff

dff u1(
    .d    (d1   ),
    .clk  (clk  ),
    .rst_n(rst_n),
    .q    (q1   )
);

dff u2(
    .d    (d2   ),
    .clk  (clk  ),
    .rst_n(rst_n),
    .q    (q2   )
);

dff u3(
    .d    (d3   ),
    .clk  (clk  ),
    .rst_n(rst_n),
    .q    (q3   )
);

endmodule