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
	vsim -voptargs=+acc fifo3_tb

