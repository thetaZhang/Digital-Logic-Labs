`timescale 1ns/1ns;
module fifo3_tb();

reg		clock,rst_n,r_en,w_en;
reg	[7:0]	in_data;
wire	[2:0]	out_data;
wire		full,empty,half_full,overflow;

reg[2:0] read_test_data [0:41];

integer i;


fifo3	FIFO(    .clk(clock),
		 .rst_n(rst_n),
		 .w_en(w_en),
		 .data_w(in_data),
		 .r_en(r_en),
		 .data_r(out_data),
		 .empty(empty),
		 .full(full),
		 .half_full(half_full),
		 .overflow(overflow));

initial//test signals status  after reset(full empty half_full)
begin
	in_data=0;
	r_en=0;
	w_en=0;
	clock=1;
	rst_n=0;
	i=1;
	#25 rst_n=1;
	
	$display("\n\ninitial done\n\n");
	if({empty,half_full,full,overflow}!=4'b1000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("after reset,status not asserted\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("initial status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end
   #25;
	//causing half_full
	for (i=1;i<9;i=i+1)
	begin
	   @(negedge clock) w_en=1; in_data=i;
		$display("storing %d  w_en=%d r_en=%d\n",i,w_en,r_en);
	end
	@(negedge clock) w_en=0;
	#10;
	if({empty,half_full,full,overflow}!=4'b0100)
	begin
		$display("\nerror at time %0t:",$time);
		$display("half_full\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("half_full status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end


	//causing full
	for (i=9;i<17;i=i+1)
	begin
	   @(negedge clock) w_en=1;in_data=i; 
		$display("storing %d  w_en=%d r_en=%d\n",i,w_en,r_en);
	end
	@(negedge clock) w_en=0;
	#25;
	if({empty,half_full,full,overflow}!=4'b0010)
	begin
		$display("\nerror at time %0t:",$time);
		$display("full\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("full status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end

	//causing overflow
	begin
	   @(negedge clock) w_en=1;in_data = 99;
		$display("storing %d  w_en=%d r_en=%d\n",i,w_en,r_en);
	end
	#25;
	if({empty,half_full,full,overflow}!=4'b0011)
	begin
		$display("\nerror at time %0t:",$time);
		$display("overflow\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("overflow status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end
	// 读前6个3bit
	@(negedge clock) w_en=0;r_en=1; // 预先进入读的状态，下个clk posedge就读出，紧接着的哪个negedge执行下面的，这样才能对比。否则一到negedge就判定，都还没读出

	@(negedge clock) w_en=0;r_en=1;
	$display("reading data %d, your data %d\n",1,out_data);
	if(out_data!=1)
	begin
		$display("expected data %d\n your data %d",1,out_data);
		$stop;
	end

	@(negedge clock) w_en=0;r_en=1;
	$display("reading data %d, your data %d\n",0,out_data);
	if(out_data!=0)
	begin
		$display("expected data %d\n your data %d",0,out_data);
		$stop;
	end

	@(negedge clock) w_en=0;r_en=1;
	$display("reading data %d, your data %d\n",0,out_data);
	if(out_data!=0)
	begin
		$display("expected data %d\n your data %d",0,out_data);
		$stop;
	end

	@(negedge clock) w_en=0;r_en=1;
	$display("reading data %d, your data %d\n",1,out_data);
	if(out_data!=1)
	begin
		$display("expected data %d\n your data %d",1,out_data);
		$stop;
	end

	@(negedge clock) w_en=0;r_en=1;
	$display("reading data %d, your data %d\n",0,out_data);
	if(out_data!=0)
	begin
		$display("expected data %d\n your data %d",0,out_data);
		$stop;
	end

	@(negedge clock) w_en=0;r_en=0;// 这个下降沿已经在读6的上升沿之后,还是1将多读一个
	$display("reading data %d, your data %d\n",6,out_data);
	if(out_data!=6)
	begin
		$display("expected data %d\n your data %d",6,out_data);
		$stop;
	end
	@(negedge clock) w_en=0;r_en=0;


	#25;
	if({empty,half_full,full,overflow}!=4'b0000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("after reading 4 data, right, empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end
	
	//write again
	@(negedge clock) r_en=0;
	#25;
	for (i=1;i<3;i=i+1)
	begin
	   @(negedge clock) w_en=1;in_data=i;
		$display("storing %d again  w_en=%d r_en=%d\n",i,w_en,r_en);
	end

	@(negedge clock) w_en=0;
	// 测试有空位但可写不足8个是能否输出满
	#25;
	if({empty,half_full,full,overflow}!=4'b0010)
	begin
		$display("\nerror at time %0t:",$time);
		$display("full\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("full status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end

	// 读出剩余的两个3bit
	@(negedge clock) w_en=0;r_en=1;
	@(negedge clock) w_en=0;r_en=1;
	$display("reading data %d, your data %d\n",0,out_data);
	if(out_data!=0)
	begin
		$display("expected data %d\n your data %d",0,out_data);
		$stop;
	end
	
	@(negedge clock) w_en=0;r_en=0;

	$display("reading data %d, your data %d\n",0,out_data);
	if(out_data!=0)
	begin
		$display("expected data %d\n your data %d",0,out_data);
		$stop;
	end
	@(negedge clock) w_en=0;r_en=0;

	#25;
	if({empty,half_full,full,overflow}!=4'b0000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("should all 0\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display(" status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end



	//重新写满
	@(negedge clock) w_en=1;in_data=3;
	$display("storing %d again  w_en=%d r_en=%d\n",3,w_en,r_en);
	@(negedge clock) w_en=0;
 	#25;
	if({empty,half_full,full,overflow}!=4'b0010)
	begin
		$display("\nerror at time %0t:",$time);
		$display("full\n");
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("full status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
	end

	$readmemb("read_test_data.txt",read_test_data);
		
	
	//read fifo all out
	@(negedge clock) w_en=0; r_en=1;	
	for (i=0;i<42;i=i+1)
	begin
	   @(negedge clock) r_en = (i == 42) ? 0 : 1;
		$display("reading data %d   %d\n",read_test_data[i],out_data);		
		if(out_data!==read_test_data[i])
		begin
			$display("date stored in %d maybe wrong\n",out_data);
			$stop;
		end	
	end

	#25;
	if({empty,half_full,full,overflow}!=4'b1000)
	begin
		$display("\nerror at time %0t:",$time);
		$display("empty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$stop;
	end
	else
	begin
		$display("empty status right\nempty = %b full = %b half_full = %b overflow = %b\n",empty,full,half_full,overflow);
		$display("********************\ndone, without error\n********************\n");
		$stop;
	end
end



always #5 clock=~clock;



endmodule


