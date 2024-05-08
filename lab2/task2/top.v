//top module

module top (
    input clk,
    input rst_n,
    input data_in,
    
    output  [2:0] data_out
);

// state definition
// 状态码本身就是当前余数，可以直接输出
    localparam  zero  = 3'b000;//余数为0
    localparam  one   = 3'b001;//余数为1
    localparam  two   = 3'b010;//余数为2
    localparam  three = 3'b011;//余数为3
    localparam  four  = 3'b100;//余数为4
    localparam  five  = 3'b101;//余数为5
    localparam  six   = 3'b110;//余数为6

// state reg
reg[2:0] state_cur,state_next;

//data_reg
reg[15:0] data;


// 第一段：状态传递
//余数状态变化
always @(posedge clk or negedge rst_n) begin
    if (~clk) begin
        state_cur <= zero;
    end
    else begin
        state_cur <= state_next;
    end
end
//16bit寄存器状态
always @(posedge clk or negedge rst_n) begin
    if (~clk) begin
        data <= 16'd0;
    end
    else begin
        data <= {data[14:0],data_in}; //通过位拼接实现移位
    end
end




// 第二段：状态选择
always @(*) begin 
    if (~data[15]) begin  // 寄存器当前的最高位影响状态转移方式，应当分开
    case (state_cur) 
        zero : state_next = (data_in) ? one   : zero;
        one  : state_next = (data_in) ? three : two;
        two  : state_next = (data_in) ? five  : four;
        three: state_next = (data_in) ? zero  : six;
        four : state_next = (data_in) ? two   : one;
        five : state_next = (data_in) ? four  : three;
        six  : state_next = (data_in) ? six   : five;
        default: state_next = zero;
    endcase
    end
    else begin
    case (state_cur)
        zero : state_next = (data_in) ? six   : five;
        one  : state_next = (data_in) ? one   : zero;
        two  : state_next = (data_in) ? three : two;
        three: state_next = (data_in) ? five  : four;
        four : state_next = (data_in) ? zero  : six;
        five : state_next = (data_in) ? two   : one; 
        six  : state_next = (data_in) ? four  : three;
        default: state_next = zero;
    endcase
    end

end

//第三段：输出
//状态码就是当前余数，可直接输出
assign data_out = state_cur; 


endmodule 