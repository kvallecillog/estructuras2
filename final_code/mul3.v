`timescale 1ns/1ps
`include "multiplicador.v"

module tester(clk, reset, a, b, c, ack, Done_Flag, producto, valid_data, ret_ack);

	output [31:0] a,b,c;
	output clk, reset, valid_data, ack;
	input [63:0] producto;
	input Done_Flag, ret_ack;

	reg clk, reset, valid_data, ack;
	reg [31:0] a,b,c;
	wire [63:0] producto;

	initial begin

	//Se guarda lo que se obtiene en un archivo
	$dumpfile("senales3.vcd");
	$dumpvars;
	clk=0;
	a=10;
	b=10;
	c=10;
	valid_data=0;
	ack = 0;
	reset = 0;

	#50 reset = 1;
	#20 reset = 0;
	#25 valid_data = 1;	

	#800 $finish;
	a=19347;
	b=0;
	valid_data=0;
	ack=0;
	
	#50 valid_data = 1;
	#400

	a=0;
	b=0;
	valid_data=0;
	ack=0;
	
	#50 valid_data = 1;
	#400 

	a=4294967295;
	b=4294967295;
	valid_data=0;
	ack=0;

	#50 valid_data = 1;
			
	#400 $finish;
	
	end

	always @(*) 
	begin
		if (Done_Flag) begin
			#23 ack = 1;
			$display("Las entradas son a = %d, b = %d y el producto es a x b = %d",a,b,producto);
		end
		
		else begin
			ack = 0;			
		end

		if (ret_ack) begin
			#23 valid_data = 0;
		end
	end

	initial begin #25 repeat(10000000) #5 clk=~clk; end

endmodule

module testbench;
		
	wire [63:0] producto_interno, producto;
	wire [31:0] a,b,c;
	
	tester test(clk, reset, a, b, c, ack, Done_Flag, producto, valid_data, ret_ack);
	multiplicador #(32) imul32(producto_interno, Done_Flag_Interno, a, b, clk, reset, valid_data, ack_interno, ret_ack);
	multiplicador #(64) imul64(producto, Done_Flag, producto_interno, c, clk, reset, Done_Flag_Interno, ack, ack_interno);

endmodule