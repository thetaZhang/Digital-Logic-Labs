//top module

module top (
    input clk,
    input rst_n,
    input data_in,
    
    output  [2:0] data_out
);

// state definition
    localparam  zero  = 3'b000;
    localparam  one   = 3'b001;
    localparam  two   = 3'b010;
    localparam  three = 3'b011;
    localparam  four  = 3'b100;
    localparam  five  = 3'b101;
    localparam  six   = 3'b110;

// state reg
reg[2:0] state_cur,state_next;

//data_reg
reg[15:0] data;


// state transition
always @(posedge clk or negedge rst_n) begin
    if (~clk) begin
        state_cur <= zero;
    end
    else begin
        state_cur <= state_next;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~clk) begin
        data <= 16'd0;
    end
    else begin
        data <= {data[14:0],data_in};
    end
end




// state switch
always @(*) begin 
    if (~data[15]) begin
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

//output 
assign data_out = state_cur; 


endmodule 