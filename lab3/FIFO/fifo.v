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
output reg  [7:0]   data_r;

//读写指针均为5bit，4bit用来指示位reg的地址，MSB用来判定空满
reg  [4:0] wr_ptr;
reg  [4:0] rd_ptr;

reg        overflow;

reg [7:0] fifo_mem [0:15];

//write function
always @(posedge clk)
if(w_en && ~full)
   fifo_mem[wr_ptr[3:0]]<=data_w;
else
   fifo_mem[wr_ptr[3:0]]<=fifo_mem[wr_ptr[3:0]];
 
//read function 
always @(posedge clk or negedge rst_n)
if(!rst_n)
   data_r<=8'bzzzzzzzz;
else if(r_en && ~empty)
   data_r<=fifo_mem[rd_ptr[3:0]];
else
   data_r<=8'bzzzzzzzz;

//wr_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   wr_ptr<=0;
else if(w_en && ~full) // 写使能且没有满时可以写
   wr_ptr<=wr_ptr+1;
else
   wr_ptr<=wr_ptr;
   
//read_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   rd_ptr<=0;
else if(r_en && ~empty) // 读使能且没有空时可以读 
   rd_ptr<=rd_ptr+1;
else
   rd_ptr<=rd_ptr;

assign  empty=(rd_ptr[4:0] == wr_ptr[4:0]);
//指针最高位不同而剩下位相同，此时两者之间恰好装了等于最大容量的数据
assign  full=(rd_ptr[4] ^ wr_ptr[4]) && (rd_ptr[3:0]==wr_ptr[3:0]);
assign  half_full=((wr_ptr-rd_ptr)==5'd8);

//overflow
always @(posedge clk or negedge rst_n)
if(!rst_n)
   overflow<=0;
else if (w_en & full)
   overflow<=1;
else
   overflow<=0;
   


endmodule 

