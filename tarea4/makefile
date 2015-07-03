CC = iverilog -o 

all:
	$(CC) testbench testbench.v

clean:
	\rm testbench

run:
	./testbench
	gtkwave pruebaPIPE.vcd
