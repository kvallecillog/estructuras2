`timescale 1ns/1ps
`include "datapath.v"
`include "FSM.v"

module multiplicador(prod, Done_Flag, a, b, clk, reset, valid_data, ack);

	output [31:0] prod;
	output Done_Flag;
	input [15:0] a, b;
	input clk,reset,valid_data,ack;

	datapath data(a, b, prod, b_sel, a_sel, prod_sel, b_lsb, add_sel, clk, reset);

	FSM control(clk, reset, valid_data, ack, b_lsb, a_sel, b_sel, prod_sel, Done_Flag);

endmodule