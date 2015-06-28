`timescale 1ns/1ps

`include "pipeline.v"







//PROBADOR DEL ID.
module probador(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);


	// Entradas.
	output reg [7:0] data;
	output reg [15:0] instr;
	output reg [9:0] newPC;
	
	
	// Salidas.
	output wire [7:0] salidaAcumA,salidaAcumB;
	output wire [9:0] branchDir;
	output wire branchTaken;
	output wire [1:0] outSelMux;
	output wire [5:0] operation;

	// Internas
	reg [9:0] clear = 0;

	initial begin
	
		$dumpfile("pruebaEXE.vcd");
		$dumpvars;

		outSelMux = 0;
		operation = `NOP;
		branchTaken = 0;

		#20 operation = `ADDA;
			salidaAcumA = 5;
			salidaAcumB = 7;


		// HAZARD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! GOOOOOOOOOL!!!
		// SI EL VALOR DEL BRANCH + EL NEWPC ES MAYOR
		// A LAS 1024 POSICIONES DE MEMORIA ENTONCES
		// EMPIEZA EN 0 DE NUEVO POR EJEMPLO NEWPC=1000
		// BRANCH=30 => 1030 Y ESTO SERÍA UN 6

		#20 branchTaken = 1;
			operation = `BACS;
		
		#20 branchTaken = 1;
			operation = `JMP;
			
		#20 $finish;
		
	end

endmodule


module tester;

	wire [7:0] data,salidaAcumA,salidaAcumB;
	wire [9:0] branchDir,newPC;
	wire [15:0] instr;
	wire branchTaken;
	wire [1:0] outSelMux;
	wire [5:0] operation;
	
	probador test(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);
	id pegado(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);

endmodule




















/*
// PROBADOR DEL PIPELINE IF_ID LISTOS.
module probador (clk,reset,wData_WB,/*wBrDir_IF,wBrTaken_IF,*/
  wAcumA_ID,wAcumB_ID,wBrDir_ID,wBrTaken_ID,wOutSelMux_ID,wOperation_ID);

	// Salidas
	output reg clk;
	output reg reset;
	//output reg wBrTaken_IF;
	//output reg [9:0] wBrDir_IF;
	output reg [7:0] wData_WB;
	
	// Entradas.
	input wire [7:0] wAcumA_ID;
	input wire [7:0] wAcumB_ID;
	input wire [9:0] wBrDir_ID;
	input wire wBrTaken_ID;
	input wire [1:0] wOutSelMux_ID;
	input wire [5:0] wOperation_ID;
	
	//assign wBrTaken_ID = wBrTaken_IF;
	

	initial begin
	
		$dumpfile("pruebaPIPE.vcd");
		$dumpvars;
		
		clk = 0;
		reset = 1;
		#23 reset = 0;
		
		wData_WB = 6;
		#5 wData_WB = 7;
		
		
		#70 $finish;
		
	end
	
	always clk = #5 ~clk;
	

endmodule


module tester;

	wire clk;
	wire reset;
	wire [7:0] wData_WB;
	//wire [9:0] wBrDir_IF;
	wire [7:0] wAcumA_ID;
	wire [7:0] wAcumB_ID;
	wire [9:0] wBrDir_ID;
	wire wBrTaken_ID;
	wire [1:0] wOutSelMux_ID;
	//wire wBrTaken_IF;
	wire [5:0] wOperation_ID;
	
	
	probador test(clk,reset,wData_WB,/*wBrDir_IF,wBrTaken_IF,*/
  wAcumA_ID,wAcumB_ID,wBrDir_ID,wBrTaken_ID,wOutSelMux_ID,wOperation_ID);
	
	
	pipeline pegado (clk,reset,wData_WB,/*wBrDir_IF,wBrTaken_IF,*/
  wAcumA_ID,wAcumB_ID,wBrDir_ID,wBrTaken_ID,wOutSelMux_ID,wOperation_ID);

endmodule

*/



























/*
// PROBADOR DEL Ifetch
module probador(clk,reset,iBr_dir,iBr_taken,oFetchedInst);


	// Entradas.
	output reg clk;
	output reg reset;
	output reg [9:0] iBr_dir;
	output reg iBr_taken;
	
	// Salidas.
	input wire [15:0] oFetchedInst;

	initial begin
	
		$dumpfile("pruebaIF.vcd");
		$dumpvars;
		
		clk = 0;
		reset = 1;
		#20 reset = 0;
		#15 iBr_dir = 50;
		    iBr_taken = 1;
		
		
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
	
	probador test(clk,reset,iBr_dir,iBr_taken,oFetchedInst);
	iFetch pegado(clk,reset,iBr_dir,iBr_taken,oFetchedInst);

endmodule
*/

















/*
//PROBADOR DEL ID.
module probador(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);


	// Entradas.
	output reg [7:0] data;
	output reg [15:0] instr;
	output reg [9:0] newPC;
	
	
	// Salidas.
	input wire [7:0] salidaAcumA,salidaAcumB;
	input wire [9:0] branchDir;
	input wire branchTaken;
	input wire [1:0] outSelMux;
	input wire [5:0] operation;

	// Internas
	reg [9:0] clear = 0;
	reg [9:0] valor;
	initial begin
	
		$dumpfile("prueba.vcd");
		$dumpvars;
		data = 10;
		newPC = 1000;
		valor = 35;
		instr = {`LDCA, valor};
		#20 instr = {`LDCB,clear};
		// HAZARD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! GOOOOOOOOOL!!!
		// SI EL VALOR DEL BRANCH + EL NEWPC ES MAYOR
		// A LAS 1024 POSICIONES DE MEMORIA ENTONCES
		// EMPIEZA EN 0 DE NUEVO POR EJEMPLO NEWPC=1000
		// BRANCH=30 => 1030 Y ESTO SERÍA UN 6
		#20 valor = 30;
			instr = {`BACS,valor};
		
		#20 valor = 524;
			instr = {`JMP,valor};
			
		#20 $finish;
		
	end

endmodule


module tester;

	wire [7:0] data,salidaAcumA,salidaAcumB;
	wire [9:0] branchDir,newPC;
	wire [15:0] instr;
	wire branchTaken;
	wire [1:0] outSelMux;
	wire [5:0] operation;
	
	probador test(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);
	id pegado(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);

endmodule
*/