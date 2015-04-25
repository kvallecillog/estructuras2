`timescale 1ns/1ps
`include "datapath.v"
`include "FSM.v"

module multiplicador(prod, Done_Flag, a, b, clk, reset, valid_data, ack);

	output [63:0] prod;
	output Done_Flag;
	input [31:0] a, b;
	input clk,reset,valid_data,ack;

	datapath data(a, b, prod, b_sel, a_sel, prod_sel, b_lsb, add_sel, clk, reset);

	FSM control(
		.Clock(clk),
		.Reset(reset),
		.valid_data(valid_data),
		.ack(ack),
		.b_lsb(b_lsb),
		.a_sel(a_sel),
		.b_sel(b_sel),
		.prod_sel(prod_sel),
		.add_sel(add_sel),
		.Done_Flag(Done_Flag)
	);

endmodule