// detect the 101101 in the seqences(non-overlapping)

module seq_detect (
    input   clk,
    input   rst_n,
    input   data_in,

    output  detector
);
    localparam STATE_0 = 3'b000;
    localparam STATE_1 = 3'b001;
    localparam STATE_2 = 3'b010;
    localparam STATE_3 = 3'b011;
    localparam STATE_4 = 3'b100;
    localparam STATE_5 = 3'b101;

    reg [2:0] state_cur, state_next;

    // one : state transfer
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            state_cur <= STATE_0;
        end
        else begin
            state_cur <= state_next;
        end
    end
    // two : state switch, using block assignment for combination-logic
    // all case items need to be displayed completely 
    always @(*)begin
        case(state_cur)
            STATE_0:
                if(data_in) state_next = STATE_1;
                else        state_next = STATE_0;
            STATE_1:
                if(data_in) state_next = STATE_1;
                else        state_next = STATE_2;
            STATE_2:
                if(data_in) state_next = STATE_3;
                else        state_next = STATE_0;
            STATE_3:
                if(data_in) state_next = STATE_4;
                else        state_next = STATE_2;
            STATE_4:
                if(data_in) state_next = STATE_1;
                else        state_next = STATE_5;
            STATE_5:
                if(data_in) state_next = STATE_0;
                else        state_next = STATE_0;
            default:        state_next = STATE_0;
        endcase
    end
    // three : output logic , using non-block assignment or block assignment    (optional)
    // block assignment
    assign detector = (state_cur == STATE_5) && data_in;

endmodule