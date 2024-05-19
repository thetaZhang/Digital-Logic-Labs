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
always @(posedge clk) // 复位不影响写入
if(w_en && ~full) // 写使能且没有满时才可以写
   fifo_mem[wr_ptr[3:0]]<=data_w; // 输入数据到当前写指针指向的寄存器
else
   fifo_mem[wr_ptr[3:0]]<=fifo_mem[wr_ptr[3:0]];
 
//read function 
always @(posedge clk or negedge rst_n)
if(!rst_n)
   data_r<=8'bzzzzzzzz;
else if(r_en && ~empty) // 读使能且非空时才可以读
   data_r<=fifo_mem[rd_ptr[3:0]];
else
   data_r<=8'bzzzzzzzz; //不读出时输出高阻

//wr_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   wr_ptr<=0; // 复位信号时恢复指针为初始值
else if(w_en && ~full) // 写使能且没有满时才可以写
   wr_ptr<=wr_ptr+1; // 写入时写指针+1，移到下一个待写空位置
else
   wr_ptr<=wr_ptr;
   
//read_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   rd_ptr<=0; // 复位时恢复读指针为初始值
else if(r_en && ~empty) // 读使能且非空时才可以读 
   rd_ptr<=rd_ptr+1; // 读出时指针+1，移到下一个待读位置
else
   rd_ptr<=rd_ptr;

// 读指针等于写指针时为空
assign  empty=(rd_ptr[4:0] == wr_ptr[4:0]);
//指针最高位不同而剩下位相同，此时两者之间恰好装了等于最大容量的数据
assign  full=(rd_ptr[4] ^ wr_ptr[4]) && (rd_ptr[3:0]==wr_ptr[3:0]);

// 存储8个数据为半满，即写指针与读指针之间差8
// 因为循环队列，读写指针大小关系不一定，如果减出负数影响判断，需要保证是大减小
assign  half_full=(((wr_ptr>rd_ptr)? (wr_ptr-rd_ptr):(rd_ptr-wr_ptr))==5'd8);

//overflow
always @(posedge clk or negedge rst_n)
if(!rst_n)
   overflow<=0;
else if (w_en & full)
   // 已经满时写使能，溢出信号将输出有效
   overflow<=1;
else
   overflow<=0;
   


endmodule 

