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
	vsim -voptargs=+acc top_tb
