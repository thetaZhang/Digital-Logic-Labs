`include "global.v"

module mac(
    input clk,
    input rst_n,
    input en,
    input first_data,
    input last_data,
    input [`WD-1:0] image_i,
    input [`WD-1:0] weight_i,
    output q_en,
    output [2*`WD:0] q
);



endmodule