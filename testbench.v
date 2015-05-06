`timescale 1ns/1ps
`include "multiplicador.v"

module tester(clk, reset, a, b, ack, Done_Flag, producto, valid_data, koala);

	output [31:0] a,b;
	output clk, reset, valid_data, ack;
	input [63:0] producto;
	input Done_Flag, koala;

	reg clk, reset, valid_data, ack;
	reg [31:0] a,b;
	wire [63:0] producto;

	initial begin

	//Se guarda lo que se obtiene en un archivo
	$dumpfile("kenny.vcd");
	$dumpvars;
	clk=0;
	a=32;
	b=3;
	valid_data=0;
	ack = 0;
	reset = 0;

	#50 reset = 1;
	#20 reset = 0;
	#25 valid_data = 1;	

	#400 reset = 1;
	a=5;
	b=5;
	valid_data=0;
	ack=0;
	reset=0;
	
	#50 valid_data = 1;		
	
	
	#400 $finish;
	
	end

	always @(*) 
	begin
		if (Done_Flag) begin
			#23 ack = 1;
			valid_data = 0;
		end
		
		else begin
			ack = 0;			
		end
	end

	initial begin #25 repeat(10000000) #5 clk=~clk; end

endmodule

module testbench;
		
	wire [63:0] producto;
	wire [31:0] a,b;
	
	tester test(clk, reset, a, b, ack, Done_Flag, producto, valid_data, koala);
	multiplicador #(32) imul(producto, Done_Flag, a, b, clk, reset, valid_data, ack, koala);

endmodule