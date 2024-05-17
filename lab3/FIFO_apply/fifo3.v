// 模块名：fifo
// 功能：8输入3输出的fifo
// 实现思路：在8to8fifo的基础上，将输出部分作为状态机来处理

`timescale 1ns/1ns;
module fifo3(clk,rst_n,w_en,data_w,r_en,data_r,full,empty,half_full,overflow);
input   clk;
input   rst_n;
input   w_en;
input   r_en;
input   [7:0] data_w;

output   full;
output   empty;
output   half_full;
output   reg overflow;
output reg  [2:0]   data_r;

//读写指针均为5bit，4bit用来指示位reg的地址，MSB用来判定空满
reg  [4:0] wr_ptr;
reg  [4:0] rd_ptr;

// 16个8biy寄存器，用于存储fifo数据
reg [7:0] fifo_mem [0:15];

// fifo输出状态和下个状态，状态值对应当前要输出的3bit和所在8bit寄存器的关系，状态值即为当前要输出的在8bit内部的位置，类似段地址和偏移地址
reg [2:0] read_state_cur,read_state_next;

// 输出状态编码，每3个8bit能够整除3，在这3个8bit寄存器中，偏移地址有8种可能值，对应8个状态，将此偏移地址作为状态码
// 状态命名规则：以3个8bit为一组，变量名中第一个数表示第几个8bit寄存器，第二个数表示这个寄存器中第几个可能的输出位置
parameter STATE1_1  = 3'b000;
parameter STATE1_2  = 3'b011;
parameter STATE1_3  = 3'b110; //会跨越两个8bit
parameter STATE2_1  = 3'b001;
parameter STATE2_2  = 3'b100;
parameter STATE2_3  = 3'b111; //会跨越两个8bit
parameter STATE3_1  = 3'b010;
parameter STATE3_2  = 3'b101;


// 输出状态迁移
always @(posedge clk or negedge rst_n) 
   if (~rst_n)
      read_state_cur <= STATE1_1;
   else if (r_en && ~empty)
      read_state_cur <= read_state_next;
   else 
      read_state_cur <= read_state_cur;

// 输出状态选择
always @(*) 
   case(read_state_cur)
      STATE1_1: read_state_next = STATE1_2;
      STATE1_2: read_state_next = STATE1_3;
      STATE1_3: read_state_next = STATE2_1;
      STATE2_1: read_state_next = STATE2_2;
      STATE2_2: read_state_next = STATE2_3;
      STATE2_3: read_state_next = STATE3_1;
      STATE3_1: read_state_next = STATE3_2;
      STATE3_2: read_state_next = STATE1_1;
   endcase

//write function
always @(posedge clk)
if(w_en && ~full)
   fifo_mem[wr_ptr[3:0]]<=data_w;
else
   fifo_mem[wr_ptr[3:0]]<=fifo_mem[wr_ptr[3:0]];

 //wr_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   wr_ptr<=0;
else if(w_en && ~full) // 写使能且没有满时可以写
   wr_ptr<=wr_ptr+1;
else
   wr_ptr<=wr_ptr;
 
//read function 
// 将段地址rd_ptr和偏移地址（当前输出状态）read_state_cer结合起来得到当前要输出的3bit数据，在两种特殊情况下，3bit分别位于两个8bit寄存器中，需要分别取值然后拼接
// 寄存器中选择一段数据时，不能用变量作为索引
always @(posedge clk or negedge rst_n)
if(!rst_n)
   data_r<=3'b0;
else if(r_en && ~empty)
   case(read_state_cur) // 注意：这里面的常数最好定义好位宽，因为若出现进位将可能不确定出现x
      STATE1_1: data_r <= fifo_mem[rd_ptr[3:0]][STATE1_1+3'd2:STATE1_1];
      STATE1_2: data_r <= fifo_mem[rd_ptr[3:0]][STATE1_2+3'd2:STATE1_2];
      STATE1_3: data_r <= {fifo_mem[rd_ptr[3:0]+4'd1][0],fifo_mem[rd_ptr[3:0]][7:STATE1_3]};
      STATE2_1: data_r <= fifo_mem[rd_ptr[3:0]][STATE2_1+3'd2:STATE2_1];
      STATE2_2: data_r <= fifo_mem[rd_ptr[3:0]][STATE2_2+3'd2:STATE2_2];
      STATE2_3: data_r <= {fifo_mem[rd_ptr[3:0]+4'd1][1:0],fifo_mem[rd_ptr[3:0]][STATE2_3]};
      STATE3_1: data_r <= fifo_mem[rd_ptr[3:0]][STATE3_1+3'd2:STATE3_1];
      STATE3_2: data_r <= fifo_mem[rd_ptr[3:0]][STATE3_2+3'd2:STATE3_2];
   endcase
else
   data_r<=3'bzzz;

//read_ptr
// 这里的rd_ptr是段地址，只有发生3bit分别位于两个8bit时才会变化，恰好读完整除3的3组8bit时也会变化，故仅在这些情况下改变rd_ptr
always @(posedge clk or negedge rst_n)
if(!rst_n)
   rd_ptr<=0;
else if(r_en && ~empty) // 读使能且没有空时可以读 
   case(read_state_cur)
      STATE1_3: rd_ptr <= rd_ptr+1;
      STATE2_3: rd_ptr <= rd_ptr+1;
      STATE3_2: rd_ptr <= rd_ptr+1;
      default: rd_ptr <= rd_ptr;
   endcase
else
   rd_ptr<=rd_ptr;

//判空
//当不够3bit时不能输出，也算空，故需添加上跨越两个8bit的两种特殊情况
assign  empty=(rd_ptr[4:0] == wr_ptr[4:0]) || ((wr_ptr[4:0] == (rd_ptr[4:0]+1)) && (read_state_cur == STATE1_3)) || ((wr_ptr[4:0] == (rd_ptr[4:0]+1)) && (read_state_cur == STATE2_3));

assign  full=(rd_ptr[4] ^ wr_ptr[4]) && (rd_ptr[3:0]==wr_ptr[3:0]);
//判半满
//原来的条件上添加8bit完整没有剩余的条件
assign  half_full=((wr_ptr-rd_ptr)==5'd8) && (read_state_cur == STATE1_1);

//overflow
always @(posedge clk or negedge rst_n)
if(!rst_n)
   overflow<=0;
else if (w_en & full)
   overflow<=1;
else
   overflow<=0;
   


endmodule 

