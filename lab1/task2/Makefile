#匹配所有.v文件
vsrc = $(wildcard *.v) 


.PHONY: init sim clean

init:
	vlib work 
	vmap work work

com: $(vsrc)
	vlog $(vsrc)

ivcom: $(vsrc)
	mkdir build
	iverilog -o ./build/top.out $(vsrc)
	vvp -n ./build/top.out

clean:
	rm build 
	
sim:
	vsim -voptargs=+acc top_tb -do "\
	add wave top_tb/clk_in;\
	add wave top_tb/rst_in;\
	add wave top_tb/q_out;\
	add wave top_tb/u1/q3;\
	add wave top_tb/u1/q2;\
	add wave top_tb/u1/q1;\
	run 100ns"
