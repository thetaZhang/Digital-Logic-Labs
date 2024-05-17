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

reg [7:0] fifo_mem [0:15];

reg [2:0] read_state_cur,read_state_next;

// 输出状态定义，1-1表示当前是每3个整除3的组中第一个字节的第一个3
//状态码表示当前字节内的读地址
parameter STATE1_1  = 3'b000;
parameter STATE1_2  = 3'b011;
parameter STATE1_3  = 3'b110;
parameter STATE2_1  = 3'b001;
parameter STATE2_2  = 3'b100;
parameter STATE2_3  = 3'b111;
parameter STATE3_1  = 3'b010;
parameter STATE3_2  = 3'b101;


// read state trans
always @(posedge clk or negedge rst_n) 
   if (~rst_n)
      read_state_cur <= STATE1_1;
   else if (r_en && ~empty)
      read_state_cur <= read_state_next;
   else 
      read_state_cur <= read_state_cur;

// read state switch
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

//只有2个或1个的情况也是空
assign  empty=(rd_ptr[4:0] == wr_ptr[4:0]) || ((wr_ptr[4:0] == (rd_ptr[4:0]+1)) && (read_state_cur == STATE1_3)) || ((wr_ptr[4:0] == (rd_ptr[4:0]+1)) && (read_state_cur == STATE2_3));
//指针最高位不同而剩下位相同，此时两者之间恰好装了等于最大容量的数据
assign  full=(rd_ptr[4] ^ wr_ptr[4]) && (rd_ptr[3:0]==wr_ptr[3:0]);
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

