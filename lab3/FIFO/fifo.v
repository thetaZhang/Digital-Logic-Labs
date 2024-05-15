`timescale 1ns/1ns;
module fifo(clk,rst_n,w_en,data_w,r_en,data_r,full,empty,half_full,overflow);
input   clk;
input   rst_n;
input   w_en;
input   r_en;
input   [7:0] data_w;

output   full;
output   empty;
output   half_full;
output   overflow;
output   [7:0]   data_r;

reg  [???:0] wr_ptr;
reg  [???:0] rd_ptr;
reg        overflow;
reg   [7:0]   data_r;
wire  [7:0]   data_in;

reg [7:0] fifo_mem [0:15];

//write function
always @(posedge clk)
if()
   fifo_mem[wr_ptr[3:0]]<=;
else
   fifo_mem[wr_ptr[3:0]]<=;
 
//read function 
always @(posedge clk or negedge rst_n)
if(!rst_n)
   data_r<=16'b0;
else if()
   data_r<=;
else
   data_r<=;

//wr_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   wr_ptr;
else if()
   wr_ptr<=;
else
   wr_ptr<=;
   
//read_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   rd_ptr<=;
else if()
   rd_ptr<=;
else
   rd_ptr<=;

assign  empty=(rd_ptr[4:0] == wr_ptr[4:0]);
assign  full=;
assign  half_full=;

//overflow
always @(posedge clk or negedge rst_n)
if(!rst_n)
   overflow<;
else
   overflow<=;
   


endmodule 

