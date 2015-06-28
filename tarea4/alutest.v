`timescale 1ns/1ps

`include "ex.v"
`include "instrDefine.v"

//PROBADOR DE LA ETAPA EXE.

//****************************************
//******           Prueba 1         ******
//****** Operaciones +, -, and, or  ******
//****************************************

// module probador(

//  output reg [7:0] iAcumA,	
//  output reg [7:0] iAcumB,
//  output reg [7:0] iConst,
//  output reg [1:0] outSelMuxExe,
//  output reg [5:0] iAluInstSel,
//  output reg [9:0] branchDir_ID,
//  input branchTaken,
//  input [9:0] branchDir_EX,
//  input [7:0] oAluData

// );

// 	// Internas
// 	reg [9:0] clear = 0;

// 	initial begin
	
// 		$dumpfile("pruebaEXE.vcd");
// 		$dumpvars;

// 		iAcumA = 15;
// 		iAcumB = 7;
// 		iConst = 10;
// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `ADDA;
// 		branchDir_ID = 0;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `ADDB;

// 		#20 

// 		outSelMuxExe = 2'b01;
// 		iAluInstSel = `ADDCA;

// 		#20 

// 		outSelMuxExe = 2'b10;
// 		iAluInstSel = `ADDCB;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `SUBA;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `SUBB;

// 		#20 

// 		outSelMuxExe = 2'b01;
// 		iAluInstSel = `SUBCA;

// 		#20 

// 		outSelMuxExe = 2'b10;
// 		iAluInstSel = `SUBCB;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `ANDA;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `ANDB;

// 		#20 

// 		outSelMuxExe = 2'b01;
// 		iAluInstSel = `ANDCA;

// 		#20 

// 		outSelMuxExe = 2'b10;
// 		iAluInstSel = `ANDCB;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `ORA;

// 		#20 

// 		outSelMuxExe = 2'b11;
// 		iAluInstSel = `ORB;

// 		#20 

// 		outSelMuxExe = 2'b01;
// 		iAluInstSel = `ORCA;

// 		#20 

// 		outSelMuxExe = 2'b10;
// 		iAluInstSel = `ORCB;

			
// 		#20 $finish;
		
// 	end

// endmodule

//****************************************
//******           Prueba 2         ******
//******Operaciones shifts y banches******
//****************************************

module probador(

 output reg [7:0] iAcumA,	
 output reg [7:0] iAcumB,
 output reg [7:0] iConst,
 output reg [1:0] outSelMuxExe,
 output reg [5:0] iAluInstSel,
 output reg [9:0] branchDir_ID,
 input branchTaken,
 input [9:0] branchDir_EX,
 input [7:0] oAluData

);

	// Internas
	reg [9:0] clear = 0;

	initial begin
	
		$dumpfile("pruebaEXE.vcd");
		$dumpvars;

		iAcumA = 15;
		iAcumB = 7;
		iConst = 10;
		outSelMuxExe = 2'b11;
		iAluInstSel = `ASLA;
		branchDir_ID = 0;

		#20 

		outSelMuxExe = 2'b11;
		iAluInstSel = `ASRA;

		#20 

		outSelMuxExe = 2'b01;
		iAluInstSel = `JMP;

		#20 

 		outSelMuxExe = 2'b11;
 		iAluInstSel = `ADDB;

 		#20 

		outSelMuxExe = 2'b01;
		iAluInstSel = `BBCC;

 		#20 

		outSelMuxExe = 2'b01;
		iAluInstSel = `BBCS;

 		#20 

 		outSelMuxExe = 2'b11;
 		iAluInstSel = `SUBB;

  		#20 

		outSelMuxExe = 2'b01;
		iAluInstSel = `BBCC;

 		#20 

		outSelMuxExe = 2'b01;
		iAluInstSel = `BBCS;

		#20 $finish;
		
	end

endmodule


module tester;

	wire [7:0] iAcumA;	
	wire [7:0] iAcumB;
	wire [7:0] iConst;
	wire [1:0] outSelMuxExe;
	wire [5:0] iAluInstSel;
	wire [9:0] branchDir_ID;
	wire branchTaken;
	wire [9:0] branchDir_EX;
	wire [7:0] oAluData;
	
	probador test(iAcumA,iAcumB,iConst,outSelMuxExe,iAluInstSel,branchDir_ID, branchTaken,branchDir_EX,oAluData);

	ex etapaEXE(iAcumA,iAcumB,iConst,outSelMuxExe,iAluInstSel,branchDir_ID, branchTaken,branchDir_EX,oAluData);

endmodule