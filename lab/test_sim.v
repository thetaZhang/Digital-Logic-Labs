`timescale 1ns/10ps
module test_sim();

reg a_in,b_in;
wire c_out;

test u1(a_in,b_in,c_out);

initial begin
    a_in=0;b_in=0;
    #10 a_in=0;b_in=1;
    #20 a_in=1;b_in=0;
    #30 a_in=1;b_in=1;
end
initial begin
    $monitor("%b,%b,%b",a_in,b_in,c_out);
end

endmodule