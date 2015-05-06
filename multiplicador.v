`timescale 1ns/1ps
`include "datapath.v"
`include "maquinaLeon.v"

module multiplicador(prod, Done_Flag, a, b, clk, reset, valid_data, ack);

	output [63:0] prod;
	output Done_Flag;
	input [31:0] a, b;
	input clk,reset,valid_data,ack;
	wire [4:0] Out;

	datapath data(a, b, prod, b_sel, a_sel, prod_sel, b_lsb, add_sel, clk, reset);
	
	FSM control(clk,reset,valid_data,ack,b_lsb,Out);
	
	assign a_sel = Out[4];
	assign b_sel = Out[3]; 
	assign prod_sel = Out[2];
	assign add_sel = Out[1];
	assign Done_Flag = Out[0];
	
	
endmodule