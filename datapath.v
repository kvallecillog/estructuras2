`timescale 1ns/1ps
`include "primitivas.v"

`define SIZE_DATA 32

module datapath(a,b,prod,b_sel,a_sel,prod_sel,b_lsb,add_sel,clk,reset);

	parameter size = `SIZE_DATA;
	// Inputs
	input [size-1:0] a,b;
	wire [size-1:0] a,b;
	input wire b_sel,a_sel,prod_sel,add_sel;
	input wire clk,reset;

	// Outputs
	output wire [2*size-1:0] prod;
	output wire b_lsb;
	
	// Mux A
	wire [size-1:0] outMuxA;
	wire [size-1:0] aShift;
	mux2NaN #(.size(32)) muxA (.select(a_sel),.d1(a),.d2(aShift),.q(outMuxA));
	
	// Mux B
	wire [size-1:0] outMuxB;
	wire [size-1:0] bShift;
	mux2NaN #(.size(32)) muxB (.select(b_sel),.d1(b),.d2(bShift),.q(outMuxB));
	
	// Mux prod
	wire [2*size-1:0] outMuxProd;
	wire [2*size-1:0] outAddSelMux;
	mux2NaN #(.size(64)) muxProd (.select(prod_sel),.d1(64'b0),.d2(outAddSelMux),.q(outMuxProd));
	
	// Reg A
	wire [size-1:0] outRegA;
	wire [size-1:0] outRegA_bar;
	regN #(.size(32)) regA (.in(outMuxA),.clk(clk),.clr(reset),.out(outRegA),.out_bar(outRegA_bar));
	
	// Reg B
	wire [size-1:0] outRegB;
	wire [size-1:0] outRegB_bar;
	regN #(.size(32)) regB (.in(outMuxB),.clk(clk),.clr(reset),.out(outRegB),.out_bar(outRegB_bar));
	// Se asigna el valor de b_lsb como el bit menos significativo de la salida del registro B.
	assign b_lsb = outRegB[0];
	
	// Reg Prod
	wire [2*size-1:0] outRegProd;
	wire [2*size-1:0] outRegProd_bar;
	regN #(.size(64)) regProd (.in(outMuxProd),.clk(clk),.clr(reset),.out(outRegProd),.out_bar(outRegProd_bar));
	
	// Shift A
	assign aShift = outRegA << 1;
	
	// Shift B
	assign bShift = outRegB >> 1;
	
	// Add A+Prod
	wire [2*size-1:0] addResult;
	adderN #(.size(64)) sumador64 ({32'b0,outRegA},outRegProd,addResult);
	
	
	// Mux add_sel
	mux2NaN #(.size(64)) muxAddSel(.select(add_sel),.d1(outRegProd),.d2(addResult),.q(outAddSelMux));
	
	assign prod = outRegProd;
	
	
endmodule