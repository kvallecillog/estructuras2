`timescale 1ns/1ps

`include "pipeline.v"

// CAMBIAR PARTE DEL ID.V DE ACUMULADORES DONDE SE DEFINE EL CONTROL DEL MODULO ACUMULADORES
// DIRECTAMENTE CONECTADO A LA SALIDA CONTROLACUM DEL MODULO ID, PORQUE ESTA ENTRADA DE CONTROL
// EN REALIDAD VIENE DEL WRITEBACK.



// PROBADOR DEL PIPELINE IF_ID LISTOS.
module probador (clk,reset);

	// Salidas
	output reg clk;
	output reg reset;
	
	// Entradas.
	

	initial begin
	
		$dumpfile("pruebaPIPE.vcd");
		$dumpvars;
		
		clk = 0;
		reset = 0;
		#5 reset = 1;
		#23 reset = 0;
				
		#500 $finish;
		
	end
	
	always clk = #5 ~clk;
	

endmodule


module tester;

	wire clk;
	wire reset;	
	
	probador test(clk,reset);
	pipeline pegado (clk,reset);

endmodule












/*

//PROBADOR DEL EXE.
module probador(iAcumA,iAcumB,iConst,outSelMuxExe,iAluInstSel,oAluData);


	// Entradas.
	output reg [7:0] data;
	output reg [15:0] instr;
	output reg [9:0] newPC;
	
	
	// Salidas.
	output wire [7:0] iAcumA,iAcumB;
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

 wire [7:0] iAcumA;	
 wire [7:0] iAcumB;
 wire [7:0] iConst;
 wire [1:0] outSelMuxExe;
 wire [5:0] iAluInstSel;
 reg [7:0] oAluData;
	
	probador test (iAcumA,iAcumB,iConst,outSelMuxExe,iAluInstSel,oAluData);
	exe pegado (iAcumA,iAcumB,iConst,outSelMuxExe,iAluInstSel,oAluData);

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
module probador(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum, memControl);


	// Entradas.
	output reg [7:0] data;
	output reg [15:0] instr;
	output reg [9:0] newPC;
	
	
	// Salidas.
	input wire [7:0] salidaAcumA,salidaAcumB;
	input wire [9:0] branchDir;
	input wire [1:0] outSelMux;
	input wire [5:0] operation;
	input wire [2:0] controlAcum;
	input wire [1:0] memControl;
	input wire [7:0] constant;

	// Internas
	reg [9:0] clear = 0;
	reg [9:0] valor;
	initial begin
	
		$dumpfile("prueba.vcd");
		$dumpvars;
		data = 10;
		newPC = 1000;
		valor = 35;
		instr = {`LDA, newPC};
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

		#20 instr = {`STA,clear};
			
		#20 $finish;
		
		
	end

endmodule


module tester;

	wire [7:0] data,salidaAcumA,salidaAcumB;
	wire [9:0] branchDir,newPC;
	wire [15:0] instr;
	wire [1:0] outSelMux;
	wire [5:0] operation;
	wire [2:0] controlAcum;
	wire [7:0] constant;
	wire [1:0] memControl;
	
	probador test(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum, memControl);
	id pegado(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum, memControl);

endmodule
*/