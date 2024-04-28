//top module

module top (
    input clk,
    input rst_n,
    input data_in,
    
    output [2:0] data_out
);

    
//16 bit shift register
reg [15:0] data_reg;
always @(posedge clk or negedge rst_n) begin
    if (~clk) 
        data_reg <= 16'd0;
    else
        data_reg <= {data_reg[14:0],data_in};
end

//output 



endmodule 