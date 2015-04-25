`timescale 1ns/1ps
`include "multiplicador.v"

module multiplicador3(prod, Done_Flag, a, b, c, clk, reset, valid_data, ack);

	output [63:0] prod;
	output Done_Flag;
	input [31:0] a, b, c;
	input clk,reset,valid_data,ack;

	wire [63:0] prodInterno;

	multiplicador mul1(prodInterno, done1, a, b, clk, reset, valid_data, ack);

	multiplicador mul2(prod, Done_Flag, prodInterno, c, clk, reset, done1, ack);

endmodule