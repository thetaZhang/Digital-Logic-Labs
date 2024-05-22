#匹配所有.v文件
vsrc = $(wildcard *.v) 


.PHONY: init sim 

init:
	vlib.exe work 
	vmap.exe work work
	mkdir .\build

com: $(vsrc)
	vlog.exe $(vsrc)

ivcom: $(vsrc)
	iverilog -o .\build\top.out $(vsrc)
	vvp -n .\build\top.out
	


sim:
	vsim.exe -voptargs=+acc fifo3_tb

