`timescale 1ns/1ps
`include "primitivas.v"
`include "FSM.v"
`include "multiplicador.v"

module tester(clk, a,b, valid, prod);

	output [15:0] a,b;
	output clk;
	input [31:0] prod;
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
	
	tester test(clk,a,b,valid,producto);
	FSM control();

endmodule