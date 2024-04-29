//top module

module top (
    input clk,
    input rst_n,
    input data_in,
    
    output reg [2:0] data_out
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
always @(*) begin
    case (data_reg[2:0])
        3'd0: data_out = 3'd0;
        3'd1: data_out = 3'd7;
        3'd2: data_out = 3'd6;
        3'd3: data_out = 3'd5;
        3'd4: data_out = 3'd4;
        3'd5: data_out = 3'd3;
        3'd6: data_out = 3'd2;
        3'd7: data_out = 3'd1;
    endcase
end



endmodule 