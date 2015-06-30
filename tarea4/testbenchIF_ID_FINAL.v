`timescale 1ns/1ps

`include "iFetch.v"
`include "id.v"


/*

// PROBADOR DEL Ifetch
module probador(clk,reset,iBr_dir,iBr_taken,oFetchedInst,oNew_pc);


	// Entradas.
	output reg clk;
	output reg reset;
	output reg [9:0] iBr_dir;
	output reg iBr_taken;
	
	// Salidas.
	input wire [15:0] oFetchedInst;
	input wire [9:0] oNew_pc;

	initial begin
	
		$dumpfile("pruebaIF.vcd");
		$dumpvars;
		
		clk = 0;
		reset = 1;
		iBr_dir = 10;
		iBr_taken = 0;
		#18 reset = 0;
		#52 iBr_taken = 1;
		#11 iBr_taken = 0;

		
		
		#50 $finish;
		
	end
	
	always clk = #5 ~clk;
	

endmodule


module tester;

	wire clk;
	wire reset;
	wire [9:0] iBr_dir;
	wire iBr_taken;
	wire [15:0] oFetchedInst;
	wire [9:0] oNew_pc;
	
	probador test(clk,reset,iBr_dir,iBr_taken,oFetchedInst,oNew_pc);
	iFetch pegado(clk,reset,iBr_dir,iBr_taken,oFetchedInst,oNew_pc);

endmodule



*/





//PROBADOR DEL ID.
module probador(data,instr,newPC,controlAcum_WB,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum_ID, memControl);


	// Salidas.
	output reg [7:0] data;
	output reg [15:0] instr;
	output reg [9:0] newPC;
	output reg [2:0] controlAcum_WB;
	
	// Entradas.
	input wire [7:0] salidaAcumA,salidaAcumB;
	input wire [9:0] branchDir;
	input wire [1:0] outSelMux;
	input wire [5:0] operation;
	input wire [2:0] controlAcum_ID;
	input wire [1:0] memControl;
	input wire [7:0] constant;


	initial begin
	
		$dumpfile("pruebaID.vcd");
		$dumpvars;
		
		instr = {`LDCA,2'b00,8'h7};
		newPC = 10'd1;
		data = 7;
		controlAcum_WB = `loadConstantA;

		#8 instr = {`LDCB,2'b00,8'h5};
		newPC = 10'd2;
		data = 5;
		controlAcum_WB = `loadConstantB;

		#8 instr = {`ADDA,10'b00};
		newPC = 10'd3;
		data = 12;
		controlAcum_WB = `loadMemoryA;

		#8 instr = {`STB,10'd50};
		newPC = 10'd4;
		data = 12;
		controlAcum_WB = `noLoad;

		#8 instr = {`BBNE,4'h0,6'h10};
		newPC = 10'd5;
		data = 7;
		controlAcum_WB = `noLoad;

		#8 instr = {`JMP,10'd500};
		newPC = 10'd11;
		data = 7;
		controlAcum_WB = `noLoad;

		#8 $finish;
		
		
	end

endmodule


module tester;

	wire [7:0] data,salidaAcumA,salidaAcumB;
	wire [9:0] branchDir,newPC;
	wire [15:0] instr;
	wire [1:0] outSelMux;
	wire [5:0] operation;
	wire [2:0] controlAcum_ID;
	wire [2:0] controlAcum_WB;
	wire [7:0] constant;
	wire [1:0] memControl;
	
	probador test(data,instr,newPC,controlAcum_WB,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum_ID, memControl);
	id pegado(data,instr,newPC,controlAcum_WB,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum_ID, memControl);

endmodule
