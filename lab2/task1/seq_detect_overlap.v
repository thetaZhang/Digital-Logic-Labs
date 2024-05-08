// detect the 101101 in the seqences(overlapping)

module seq_detect_overlap(
    input clk,
    input rst_n,
    input data_in,

    output detector

);

    //set state
    localparam STATE_0 = 3'b000;
    localparam STATE_1 = 3'b001;
    localparam STATE_2 = 3'b010;
    localparam STATE_3 = 3'b011;
    localparam STATE_4 = 3'b100;
    localparam STATE_5 = 3'b101;



    reg [2:0] state_cur,state_next;  // now state and next state

    //state transfer
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state_cur <= STATE_0;
        else 
            state_cur <= state_next;
    end

    //state state switch
    always @(*) begin
        case (state_cur) 
            STATE_0: state_next = (data_in) ? STATE_1 : STATE_0;
            STATE_1: state_next = (data_in) ? STATE_1 : STATE_2;
            STATE_2: state_next = (data_in) ? STATE_3 : STATE_0;
            STATE_3: state_next = (data_in) ? STATE_4 : STATE_2;
            STATE_4: state_next = (data_in) ? STATE_1 : STATE_5;
            STATE_5: state_next = (data_in) ? STATE_3 : STATE_0; // 相比非重叠，STATE_5的状态转移条件改变
            default: state_next = STATE_0;
        endcase
    end

    //output
    assign detector=(state_cur==STATE_5) && data_in;

endmodule