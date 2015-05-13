`timescale 1ns/1ps
`include "primitivas.v"

`define SIZE_DATA 32

module datapath(a32,b,prod,b_sel,a_sel,prod_sel,b_lsb,add_sel,clk,reset, enable);

	parameter size = `SIZE_DATA;
	// Inputs
	input [size-1:0] a32,b;
	wire [2*size-1:0] a;
	input wire b_sel,a_sel,prod_sel,add_sel;
	input wire clk,reset, enable;

	// extras
	reg [size-1:0] clear = 0;
	assign a = {clear,a32};
	reg [2*size-1:0] clear2 = 0;
	
	// Outputs
	output wire [2*size-1:0] prod;
	output wire b_lsb;
	
	// Mux A
	wire [2*size-1:0] outMuxA;
	wire [2*size-1:0] aShift;
	mux2NaN #(.size(2*size)) muxA (.select(a_sel),.d1(a),.d2(aShift),.q(outMuxA));
	
	// Mux B
	wire [size-1:0] outMuxB;
	wire [size-1:0] bShift;
	mux2NaN #(.size(size)) muxB (.select(b_sel),.d1(b),.d2(bShift),.q(outMuxB));
	
	// Mux prod
	wire [2*size-1:0] outMuxProd;
	wire [2*size-1:0] outAddSelMux;
	mux2NaN #(.size(2*size)) muxProd (.select(prod_sel),.d1(clear2),.d2(outAddSelMux),.q(outMuxProd));
	
	// Reg A
	wire [2*size-1:0] outRegA;
	wire [2*size-1:0] outRegA_bar;
	regN #(.size(2*size)) regA (.in(outMuxA),.clk(clk),.clr(reset),.enable(enable),.out(outRegA),.out_bar(outRegA_bar));
	
	// Reg B
	wire [size-1:0] outRegB;
	wire [size-1:0] outRegB_bar;
	regN #(.size(size)) regB (.in(outMuxB),.clk(clk),.clr(reset),.enable(enable),.out(outRegB),.out_bar(outRegB_bar));
	// Se asigna el valor de b_lsb como el bit menos significativo de la salida del registro B.
	assign b_lsb = outMuxB[0];
	
	// Reg Prod
	wire [2*size-1:0] outRegProd;
	wire [2*size-1:0] outRegProd_bar;
	regN #(.size(2*size)) regProd (.in(outMuxProd),.clk(clk),.clr(reset),.enable(enable),.out(outRegProd),.out_bar(outRegProd_bar));
	
	// Shift A
	assign aShift = outRegA << 1;
	
	// Shift B
	assign bShift = outRegB >> 1;
	
	// Add A+Prod
	wire [2*size-1:0] addResult;
	adderN #(.size(2*size)) sumador64 (outRegA,outRegProd,addResult);
	
	
	// Mux add_sel
	mux2NaN #(.size(2*size)) muxAddSel(.select(add_sel),.d1(outRegProd),.d2(addResult),.q(outAddSelMux));
	
	assign prod = outRegProd;
	
	
endmodule