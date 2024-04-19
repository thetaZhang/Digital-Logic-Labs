`timescale 1ns/10ps

module top_tb();

localparam CLOCK_PERIOD = 10;

reg clk_in,rst_in;

wire q_out;

always #(CLOCK_PERIOD / 2) clk_in = ~clk_in;

initial begin 
    clk_in = 0;
    rst_in = 1;
    #10 rst_in = 0;
    #10 rst_in = 1;
end

initial begin
$monitor("%b",q_out);
end

top u1(
    .clk(clk_in),
    .rst_n(rst_in),
    .q(q_out)
);



endmodule
