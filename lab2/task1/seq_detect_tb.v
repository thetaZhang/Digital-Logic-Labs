`timescale 1ns/100ps
module seq_detect_tb;

    // Signal declarations
    reg clk, rst_n, data_in;
    wire detector;

    // Instantiate the design under test (DUT)
    seq_detect_overlap DUT (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .detector(detector)
    );

    // Generate clock 
    initial begin
        clk = 0;
        forever #5 clk = ~clk; //  10ns period
    end

    // Stimulus and monitoring
    initial begin
        rst_n = 1;
        data_in =0;
        #20 rst_n = 0;  // Apply a reset pulse
        #25 rst_n = 1;
        // ... Generate your test sequence here ...
        #10 data_in = 1;
        #100 data_in =0;
        #100 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =0;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =1;
        #10 data_in =0;
        #10 data_in =1;
        #10 data_in =0;
        #500 $finish;  // End the simulation
    end




endmodule