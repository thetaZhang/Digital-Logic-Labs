`timescale 1ns/100ps
module top_tb;

    reg clk,rst_n,data_in;
    wire [2:0] data_out;

    wire [15:0] data_reg;

    integer i;

    top u1(
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .data(data_reg)
    );


    initial begin
        clk = 0;
        rst_n = 1;
        data_in = 0;
        #20 rst_n = 0;
        #25 rst_n = 1;
        for (i=0; i<=2000; i=i+1) begin
            clk = ~clk;
            #5 clk = ~clk;
            #4 data_in = {$random}%(2'd2);
            if (data_out != (data_reg % 3'd7)) 
                $display("Error: data_out = %d, data_reg = %d,i = %d",data_out,data_reg,i);
            #1;
        end

        $finish;
    end



endmodule