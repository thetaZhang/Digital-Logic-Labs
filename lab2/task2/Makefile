#匹配所有.v文件
vsrc = $(wildcard *.v) 


.PHONY: init sim 

init:
	vlib work 
	vmap work work
	mkdir .\build

com: $(vsrc)
	vlog $(vsrc)

ivcom: $(vsrc)
	iverilog -o .\build\top.out $(vsrc)
	vvp -n .\build\top.out
	


sim:
	vsim -voptargs=+acc top_tb -do "\
	add wave top_tb/clk;\
	add wave top_tb/rst_n;\
	add wave top_tb/data_in;\
	add wave top_tb/data_reg;\
	add wave top_tb/data_out;\
	
	run 20000ns"
