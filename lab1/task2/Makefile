#匹配所有.v文件
vsrc = $(wildcard *.v) 


.PHONY: init sim 

init:
	vlib work 
	vmap work work

com: $(vsrc)
	vlog $(vsrc)


sim:
	vsim -voptargs=+acc top_tb
