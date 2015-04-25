`timescale 1ns/1ps
`include "mul3.v"

module tester(clk, reset, a, b, c, ack, Done_Flag, producto, valid_data);

	output [31:0] a,b,c;
	output clk, reset, valid_data, ack;
	input [63:0] producto;
	input Done_Flag;

	reg clk, reset, valid_data, ack;
	reg [31:0] a,b,c;
	wire [63:0] producto;

	initial begin

	//Se guarda lo que se obtiene en un archivo
	$dumpfile("sim3.vcd");
	$dumpvars;
	clk=0;
	a=4;
	b=3;
	c=2;
	valid_data=0;
	ack = 0;
	reset = 0;

	#50 reset = 1;
	#20 reset = 0;
	#20 valid_data = 1;	

	#800 $finish;
	end

	always @(*) 
	begin
		if (Done_Flag) begin
			ack = 1;	
		end
		else
		begin
			ack = 0;			
		end
	end

	initial begin #25 repeat(100) #5 clk=~clk; end

endmodule

module testbench;
		
	wire [63:0] producto;
	wire [31:0] a,b,c;
	
	tester test(clk, reset, a, b, c, ack, Done_Flag, producto, valid_data);
	multiplicador3 imul(producto, Done_Flag, a, b, c, clk, reset, valid_data, ack);

endmodule