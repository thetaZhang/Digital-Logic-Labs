module ReLU (
    input  wire       clk,
    input  wire       rst_n,
    input             out_en,
    input  wire [7:0] input_data,
    output reg  [7:0] output_data
);

  wire [7:0] cal_data;  //assign只能赋值wire
  assign cal_data = input_data[7] ? 8'b0 : input_data;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) output_data <= 8'b0;
    else begin
      if (out_en) output_data <= cal_data;  //output calculated data when out_en is high
      else output_data <= output_data;  //写全所有分支
    end
  end

endmodule
