`timescale 1ns/1ps
`include "datapath.v"
`include "maquinaLeon.v"

`define SIZE_MUL 32

module multiplicador(prod, Done_Flag, a, b, clk, reset, valid_data, ack, ret_ack);

	parameter size = `SIZE;

	output [2*size-1:0] prod;
	output Done_Flag, ret_ack;
	input [size-1:0] a, b;
	input clk,reset,valid_data,ack;
	wire [6:0] Out;

	datapath data(a, b, prod, b_sel, a_sel, prod_sel, b_lsb, add_sel, clk, reset, enable);
	
	FSM control(clk,reset,valid_data,ack,b_lsb,Out);
	
	assign a_sel = Out[6];
	assign b_sel = Out[5]; 
	assign prod_sel = Out[4];
	assign add_sel = Out[3];
	assign Done_Flag = Out[2];
	assign enable = Out[1];
	assign ret_ack = Out[0];
	
endmodule