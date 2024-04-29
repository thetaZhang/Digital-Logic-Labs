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
	vsim -L work -voptargs=+acc lab1_tb -do "\
	add wave lab1_tb/clk_reg;\
	add wave lab1_tb/resetn_reg;\
	add wave lab1_tb/u_counter/counter;\
	add wave lab1_tb/relu_input_data;\
	add wave lab1_tb/out_en;\
	add wave lab1_tb/relu_output_data;\
	run 3000ns"
