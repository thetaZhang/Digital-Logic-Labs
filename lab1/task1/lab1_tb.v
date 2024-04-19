`timescale 1ns/10ps

module lab1_tb
();
    localparam CLOCK_PERIOD = 10;
    localparam COUNTER_THRESHOLD = 120;

    reg  clk_reg;
    reg  resetn_reg;
    wire out_en;
    reg  [7:0] relu_input_data;
    wire [7:0] relu_output_data;

    always #(CLOCK_PERIOD / 2) clk_reg = ~clk_reg;

    initial begin
    clk_reg = 0;
    resetn_reg = 0;
    relu_input_data = 8'b10011010;
    #100 resetn_reg = 1;
    #2200 relu_input_data = 8'b00101110;
    end

counter#(
    .THRESHOLD(COUNTER_THRESHOLD)
)
u_counter(
    .clk   (clk_reg   ),
    .rst_n (resetn_reg),
    .out_en(out_en     )
);

ReLU u_relu(
    .clk_reg         (clk        ),
    .resetn_reg      (rst_n      ),
    .out_en          (out_en     ),
    .relu_input_data (input_data ),
    .relu_output_data(output_data)
);


endmodule