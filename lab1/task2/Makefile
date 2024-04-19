vsrc = *.v

.PHONY: init

init:
	vlib work 
	vmap work work

com: $(vsrc)
	vlog $(vsrc)

.PHONY: sim

sim:
	vsim vsim -voptargs=+acc+top_tb top_tb
