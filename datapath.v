`timescale 1ns/1ps
`include "primitivas.v"

module datapath(a,b,prod,b_sel,a_sel,prod_sel,b_lsb,add_sel,clk,reset);

	// Inputs
	input [31:0] a,b;
	wire [31:0] a,b;
	input wire b_sel,a_sel,prod_sel,add_sel;
	input wire clk,reset;

	// Outputs
	output wire [63:0] prod;
	output wire b_lsb;
	
	// Mux A
	wire [31:0] outMuxA;
	wire [31:0] aShift;
	mux64a32 muxA (.select(a_sel),.d1(a),.d2(aShift),.q(outMuxA));
	
	// Mux B
	wire [31:0] outMuxB;
	wire [31:0] bShift;
	mux64a32 muxB (.select(b_sel),.d1(b),.d2(bShift),.q(outMuxB));
	
	// Mux prod
	wire [63:0] outMuxProd;
	wire [63:0] outAddSelMux;
	mux128a64 muxProd (.select(prod_sel),.d1(64'b0),.d2(outAddSelMux),.q(outMuxProd));
	
	// Reg A
	wire [31:0] outRegA;
	wire [31:0] outRegA_bar;
	reg32 regA (.in(outMuxA),.clk(clk),.clr(reset),.out(outRegA),.out_bar(outRegA_bar));
	
	// Reg B
	wire [31:0] outRegB;
	wire [31:0] outRegB_bar;
	reg32 regB (.in(outMuxB),.clk(clk),.clr(reset),.out(outRegB),.out_bar(outRegB_bar));
	// Se asigna el valor de b_lsb como el bit menos significativo de la salida del registro B.
	assign b_lsb = outRegB[0];
	
	// Reg Prod
	wire [63:0] outRegProd;
	wire [63:0] outRegProd_bar;
	reg64 regProd (.in(outMuxProd),.clk(clk),.clr(reset),.out(outRegProd),.out_bar(outRegProd_bar));
	
	// Shift A
	assign aShift = outRegA << 1;
	
	// Shift B
	assign bShift = outRegB >> 1;
	
	// Add A+Prod
	wire [63:0] addResult;
	adder64 sumador64 ({32'b0,outRegA},outRegProd,addResult);
	
	
	// Mux add_sel
	mux128a64 muxAddSel(.select(add_sel),.d1(addResult),.d2(outRegProd),.q(outAddSelMux));
	
	assign prod = outRegProd;
	
	
endmodule