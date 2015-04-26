`timescale 1ns/1ps
`include "multiplicador.v"

module tester(clk, reset, a, b, ack, Done_Flag, producto, valid_data);

	output [31:0] a,b;
	output clk, reset, valid_data, ack;
	input [63:0] producto;
	input Done_Flag;

	reg clk, reset, valid_data, ack;
	reg [31:0] a,b;
	wire [63:0] producto;

	initial begin

	//Se guarda lo que se obtiene en un archivo
	$dumpfile("kenny.vcd");
	$dumpvars;
	clk=0;
	a=32'hFFFFFFFF;
	b=32'hFFFFFFFF;
	valid_data=0;
	ack = 0;
	reset = 0;

	#50 reset = 1;
	#20 reset = 0;
	#25 valid_data = 1;	

	#400 $finish;
	end

	always @(*) 
	begin
		if (Done_Flag) begin
			ack = 1;
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
	
	tester test(clk, reset, a, b, ack, Done_Flag, producto, valid_data);
	multiplicador #(32) imul(producto, Done_Flag, a, b, clk, reset, valid_data, ack);

endmodule