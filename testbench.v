`timescale 1ns/1ps
`include "multiplicador.v"

module tester(clk, reset, a, b, ack, valid, producto, ready);

	output [15:0] a,b;
	output clk, ready;
	input [31:0] producto;
	input valid;

	reg clk,valid;
	reg [15:0] a,b;
	wire [31:0] prod;

	//Se guarda lo que se obtiene en un archivo
	$dumpfile("kenny.vcd");
	$dumpvars;
	clk=0;
	a=16;
	b=31;

	initial begin #25 repeat(1000) #5 clk=~clk; end

endmodule

module testbench;
		
	wire [31:0] producto;
	wire [15:0] a,b;
	
	tester test(clk, reset, a, b, ack, Done_Flag, producto, ready);
	multiplicador imul(producto, Done_Flag, a, b, clk, reset, ready, ack);

endmodule