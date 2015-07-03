`timescale 1ns/1ps

`include "instrDefine.v"

// ---------------------------------------------------------------------------------------------
module iFetch(clk,reset,iBr_dir,iBr_taken,oFetchedInst,oNew_pc);

	// Se define las entradas del modulo IF:
	// - br_dir: direccion que se carga al pc cuando cuando un branch es tomado.
	// - br_taken: bit de seleccion para saber si cargar newPC o PC + 1
	input [`LENGTH_INSTR_MEM-1:0] iBr_dir;
	input iBr_taken;
	input reset;
	input clk;
	
	// Se definen las salidas del modulo IF.
	// - fetched_inst: direccion de 10 bits con los datos de la siguiente instruccion a decodificar
	output wire [`WIDTH_INSTR_MEM-1:0] oFetchedInst;
	output wire [`LENGTH_INSTR_MEM-1:0] oNew_pc;

	
	// Internas
	wire [`LENGTH_INSTR_MEM-1:0] wPc_pointer;
	
	pc pcIF(clk,reset,iBr_dir,iBr_taken,wPc_pointer,oNew_pc);
	
	ROM instructMem(wPc_pointer,oFetchedInst);
	
endmodule






// ---------------------------------------------------------------------------------------------
// 
module pc(clk,reset,iBr_dir,iBr_taken,oPc_pointer,oNew_pc);

	// Entradas
	// - clk: señal que le indica al PC que debe de actualizar su valor
	// - br_dir: direccion calculada cuando se tomaría el branch
	// - br_taken: bit que se pone en uno si un branch debe de ser tomado

	input clk;
	input reset;
	input [`LENGTH_INSTR_MEM-1:0] iBr_dir;
	input iBr_taken;
	
	
	// Salidas
	// Salida del contador de programa. Es igual a pc_anterior + 1 o igual a br_dir dependiendo de si se tomó
	// o no se tomo el branch
	output reg [`LENGTH_INSTR_MEM-1:0] oPc_pointer;
	output reg [`LENGTH_INSTR_MEM-1:0] oNew_pc;
	
	always @(posedge clk) begin

	  if (reset) oPc_pointer = 0;
	  
	  else begin
	    
	    if (iBr_taken) oPc_pointer = iBr_dir;
		
	    else oPc_pointer = oPc_pointer + 1;
		

	  end

	  oNew_pc = oPc_pointer + 1;
	    
	end
	
endmodule



//////////////////////////////////////////////////////////////////
module ROM(iDir,oInstruc);

  // Entrada
  input [`LENGTH_INSTR_MEM-1:0] iDir;
  
  // Salida
  output reg [`WIDTH_INSTR_MEM-1:0] oInstruc;

  
  // Internas
  reg [9:0] rClear = 0;
  
  
  always @(*) begin
   
   case(iDir)


// Codigo de prueba de la operacion de la instruccion SUBCB y BCCC.

 	 	0: oInstruc = {`LDCB,2'd0,8'HFF};
		1: oInstruc = {`NOP,rClear};
		2: oInstruc = {`NOP,rClear};
		3: oInstruc = {`SUBCB,2'd0,8'h1};  
		4: oInstruc = {`NOP,rClear};
		5: oInstruc = {`BBCC,4'b0,6'b100110};
 		6: oInstruc = {`LDCA,2'b00,8'H1};	


// Prueba de escritura, lectura y sobre carga de constante a los acumuladores.

        7: oInstruc = {`LDCA,2'b00,8'hff};
      	8 : oInstruc = {`NOP,rClear};
 		9 : oInstruc = {`NOP,rClear};
 		10 : oInstruc = {`NOP,rClear};
      	11: oInstruc = {`STA,10'd1}; 
 		12 : oInstruc = {`NOP,rClear};
 		13 : oInstruc = {`NOP,rClear};
 		14 : oInstruc = {`NOP,rClear};
		15 : oInstruc = {`LDA,10'd1};  
		16 : oInstruc = {`NOP,rClear};
		17 : oInstruc = {`NOP,rClear};
		18 : oInstruc = {`NOP,rClear};
		19: oInstruc = {`LDCB,2'b00,8'd00};
		20 : oInstruc = {`NOP,rClear};
 		21 : oInstruc = {`NOP,rClear};
 		22 : oInstruc = {`NOP,rClear};
		23 : oInstruc = {`STB,10'd2};  
		24 : oInstruc = {`NOP,rClear};
 		25: oInstruc = {`NOP,rClear};
 		26 : oInstruc = {`NOP,rClear};
 		27 : oInstruc = {`LDB,10'd2};
 		28: oInstruc = {`NOP,rClear};
 		29: oInstruc = {`NOP,rClear};
 		30 : oInstruc = {`NOP,rClear};
 		31 : oInstruc = {`SUBA,rClear}; 
 		32: oInstruc = {`LDCA,2'b00,8'hff};
      	33 : oInstruc = {`NOP,rClear};
 		34: oInstruc = {`NOP,rClear};
 		35 : oInstruc = {`NOP,rClear};
      	36: oInstruc = {`STA,10'd1}; 
 		37 : oInstruc = {`NOP,rClear};
 		38 : oInstruc = {`NOP,rClear};
 		39 : oInstruc = {`NOP,rClear};
		40 : oInstruc = {`LDA,10'd1};  
		41 : oInstruc = {`NOP,rClear};
		42 : oInstruc = {`NOP,rClear};
		43 : oInstruc = {`NOP,rClear};
		44: oInstruc = {`LDCB,2'b00,8'd00};
		45 : oInstruc = {`NOP,rClear};
 		46 : oInstruc = {`NOP,rClear};
 		47 : oInstruc = {`NOP,rClear};
		48 : oInstruc = {`STB,10'd2};  
		49 : oInstruc = {`NOP,rClear};
 		50: oInstruc = {`NOP,rClear};
 		51 : oInstruc = {`NOP,rClear};
 		52 : oInstruc = {`LDB,10'd2};
 		53: oInstruc = {`NOP,rClear};
 		54: oInstruc = {`NOP,rClear};
 		55 : oInstruc = {`NOP,rClear};
 		56 : oInstruc = {`SUBA,rClear}; 

// Prueba de ADDA y de la bandera BCA.

 		57 : oInstruc = {`LDCB,2'd0,8'H0F};
		58: oInstruc = {`NOP,rClear};
		59 : oInstruc = {`NOP,rClear};
		60 : oInstruc = {`NOP,rClear};
		61 : oInstruc = {`LDCA,2'd0,8'HF0};
		62 : oInstruc = {`NOP,rClear};
		63 : oInstruc = {`NOP,rClear};
		64: oInstruc = {`NOP,rClear};
		65: oInstruc = {`ADDA,rClear};  
		66: oInstruc = {`NOP,rClear};
		67 : oInstruc = {`NOP,rClear};
		68 : oInstruc = {`NOP,rClear};
		69 : oInstruc = {`ADDA,rClear};  
		70: oInstruc = {`NOP,rClear};
		71 : oInstruc = {`NOP,rClear};
		72 : oInstruc = {`NOP,rClear};
		73 : oInstruc = {`LDCB,2'd0,8'd1};
		74: oInstruc = {`NOP,rClear};
		75: oInstruc = {`NOP,rClear};
		76: oInstruc = {`NOP,rClear};
		77: oInstruc = {`ADDA,rClear};  
		78: oInstruc = {`NOP,rClear};
		79 : oInstruc = {`NOP,rClear};
		80 : oInstruc = {`NOP,rClear};
		//Prueba ADDB
 		81: oInstruc = {`LDCB,2'd0,8'H0F};
		82 : oInstruc = {`NOP,rClear};
		83: oInstruc = {`NOP,rClear};
		84: oInstruc = {`NOP,rClear};
		85: oInstruc = {`LDCA,2'd0,8'HF0};
		86: oInstruc = {`NOP,rClear};
		87: oInstruc = {`NOP,rClear};
		89: oInstruc = {`NOP,rClear};
		90: oInstruc = {`ADDB,rClear};  
		91: oInstruc = {`NOP,rClear};
		92 : oInstruc = {`NOP,rClear};
		93 : oInstruc = {`NOP,rClear};
		94 : oInstruc = {`ADDB,rClear};  
		95: oInstruc = {`NOP,rClear};
		96 : oInstruc = {`NOP,rClear};
		97 : oInstruc = {`NOP,rClear};
		98 : oInstruc = {`LDCA,2'd0,8'd1};
		99: oInstruc = {`NOP,rClear};
		100: oInstruc = {`NOP,rClear};
		101: oInstruc = {`NOP,rClear};
		102: oInstruc = {`ADDB,rClear};  
		103: oInstruc = {`NOP,rClear};
		104: oInstruc = {`NOP,rClear};
		105: oInstruc = {`NOP,rClear};


 	// // Prueba de SUBA y de la bandera BAZ.

 		106 : oInstruc = {`LDCB,2'd0,8'D15};
		107 : oInstruc = {`NOP,rClear};
		108: oInstruc = {`NOP,rClear};
		109 : oInstruc = {`NOP,rClear};
		110 : oInstruc = {`LDCA,2'd0,8'D15};
		111 : oInstruc = {`NOP,rClear};
		112 : oInstruc = {`NOP,rClear};
		113: oInstruc = {`NOP,rClear};
		114 : oInstruc = {`SUBA,rClear};  
		115: oInstruc = {`NOP,rClear};
		116 : oInstruc = {`NOP,rClear};
		117 : oInstruc = {`NOP,rClear};
	

 
	// // Prueba ANDA FF 00 Y ANDB

		118 : oInstruc = {`LDCA,2'b00,8'hFF};  
 		119: oInstruc = {`NOP,rClear};
 		120 : oInstruc = {`NOP,rClear};
 		121 : oInstruc = {`NOP,rClear};
		122 : oInstruc = {`LDCB,2'b00,8'h00};  
		123 : oInstruc = {`NOP,rClear};
		124 : oInstruc = {`NOP,rClear};
		125: oInstruc = {`NOP,rClear};
		126 : oInstruc = {`ANDA,rClear};  
		127 : oInstruc = {`NOP,rClear};
 		128 : oInstruc = {`NOP,rClear};
 		129 : oInstruc = {`NOP,rClear};
		130 : oInstruc = {`LDCA,2'b00,8'h00};  
 		131 : oInstruc = {`NOP,rClear};
 		132 : oInstruc = {`NOP,rClear};
 		133: oInstruc = {`NOP,rClear};
		134 : oInstruc = {`LDCB,2'b00,8'hFF};  
		135: oInstruc = {`NOP,rClear};
		136 : oInstruc = {`NOP,rClear};
		137: oInstruc = {`NOP,rClear};
		138: oInstruc = {`ANDB,rClear};  
		139: oInstruc = {`NOP,rClear};
 		140 : oInstruc = {`NOP,rClear};

	// // Prueba ANDA Y ANDB FF 00

		141: oInstruc = {`LDCA,2'b00,8'b00110101};  
 		142 : oInstruc = {`NOP,rClear};
 		143 : oInstruc = {`NOP,rClear};
 		144 : oInstruc = {`NOP,rClear};
		145 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		146 : oInstruc = {`NOP,rClear};
		147 : oInstruc = {`NOP,rClear};
		148 : oInstruc = {`NOP,rClear};
		149 : oInstruc = {`ANDA,rClear};  
		150 : oInstruc = {`NOP,rClear};
 		151 : oInstruc = {`NOP,rClear};
 		152 : oInstruc = {`NOP,rClear};	
		153 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 		154 : oInstruc = {`NOP,rClear};
 		155 : oInstruc = {`NOP,rClear};
 		156 : oInstruc = {`NOP,rClear};
		157 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		158 : oInstruc = {`NOP,rClear};
		159: oInstruc = {`NOP,rClear};
		160 : oInstruc = {`NOP,rClear};
		161: oInstruc = {`ANDB,rClear};  
		162: oInstruc = {`NOP,rClear};
 		163 : oInstruc = {`NOP,rClear};
 		164 : oInstruc = {`NOP,rClear};			
     

	// // Prueba ORA FF 00 Y ORB

		165 : oInstruc = {`LDCA,2'b00,8'hFF};  
 		166 : oInstruc = {`NOP,rClear};
 		167 : oInstruc = {`NOP,rClear};
 		168 : oInstruc = {`NOP,rClear};
		169 : oInstruc = {`LDCB,2'b00,8'h00};  
		170 : oInstruc = {`NOP,rClear};
		171 : oInstruc = {`NOP,rClear};
		172 : oInstruc = {`NOP,rClear};
		173 : oInstruc = {`ORA,rClear};  
		174 : oInstruc = {`NOP,rClear};
 		175 : oInstruc = {`NOP,rClear};
 		176 : oInstruc = {`NOP,rClear};
		177: oInstruc = {`LDCA,2'b00,8'hFF};  
 		178 : oInstruc = {`NOP,rClear};
 		179 : oInstruc = {`NOP,rClear};
 		180 : oInstruc = {`NOP,rClear};
		181 : oInstruc = {`LDCB,2'b00,8'h00};  
		182 : oInstruc = {`NOP,rClear};
		183 : oInstruc = {`NOP,rClear};
		184: oInstruc = {`NOP,rClear};
		185: oInstruc = {`ORB,rClear};  
		186: oInstruc = {`NOP,rClear};
 		187 : oInstruc = {`NOP,rClear};

	// // Prueba ANDA Y ANDB TODOS LOS BITS CAMBIANDO

		188 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 		189 : oInstruc = {`NOP,rClear};
 		190 : oInstruc = {`NOP,rClear};
 		191 : oInstruc = {`NOP,rClear};
		192 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		193 : oInstruc = {`NOP,rClear};
		194 : oInstruc = {`NOP,rClear};
		195 : oInstruc = {`NOP,rClear};
		196 : oInstruc = {`ORA,rClear};  
		197 : oInstruc = {`NOP,rClear};
 		199 : oInstruc = {`NOP,rClear};
 		200 : oInstruc = {`NOP,rClear};	
		201 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 		202 :  oInstruc = {`NOP,rClear};
 		203 : oInstruc = {`NOP,rClear};
 		204 : oInstruc = {`NOP,rClear};
		205 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		206 : oInstruc = {`NOP,rClear};
		207: oInstruc = {`NOP,rClear};
		208: oInstruc = {`NOP,rClear};
		209: oInstruc = {`ORB,rClear};  
		210: oInstruc = {`NOP,rClear};
 		211 : oInstruc = {`NOP,rClear};
 		212: oInstruc = {`NOP,rClear};

		// // Prueba de ASLA

 	 213 : oInstruc = {`LDCA,2'b00,8'HFF};  
 	 214 : oInstruc = {`NOP,rClear};
 	215 : oInstruc = {`NOP,rClear};
 		216 : oInstruc = {`NOP,rClear};
		217 : oInstruc = {`ASLA,rClear};  
		218 : oInstruc = {`NOP,rClear};
		219: oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`ASLA,rClear};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ASLA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
		// 10 : oInstruc = {`NOP,rClear};
		// 11 : oInstruc = {`NOP,rClear};
		// 12 : oInstruc = {`ASLA,rClear};  
		// 13 : oInstruc = {`NOP,rClear};
		// 14 : oInstruc = {`NOP,rClear};
		// 15 : oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`ASLA,rClear};  
		// 17 : oInstruc = {`NOP,rClear};
		// 18 : oInstruc = {`NOP,rClear};
		// 19: oInstruc = {`NOP,rClear};
		// 20 : oInstruc = {`ASLA,rClear};  
		// 21 : oInstruc = {`NOP,rClear};
		// 22 : oInstruc = {`NOP,rClear};
		// 23 : oInstruc = {`NOP,rClear};
		// 24 : oInstruc = {`ASLA,rClear};  
		// 25 : oInstruc = {`NOP,rClear};
		// 26 : oInstruc = {`NOP,rClear};
		// 27 : oInstruc = {`NOP,rClear};
		// 28 : oInstruc = {`ASLA,rClear};  
		// 29 : oInstruc = {`NOP,rClear};
		// 30 : oInstruc = {`NOP,rClear};
		// 31 : oInstruc = {`NOP,rClear};
		// 32 : oInstruc = {`ASLA,rClear};  
		// 33 : oInstruc = {`NOP,rClear};
		// 34 : oInstruc = {`NOP,rClear};
		// 35 : oInstruc = {`NOP,rClear};

// Prueba de ASRA

 	// 	0 : oInstruc = {`LDCA,2'b00,8'b11100000};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`ASRA,rClear};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`ASRA,rClear};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ASRA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
		// 10 : oInstruc = {`NOP,rClear};
		// 11 : oInstruc = {`NOP,rClear};
		// 12 : oInstruc = {`ASRA,rClear};  
		// 13 : oInstruc = {`NOP,rClear};
		// 14 : oInstruc = {`NOP,rClear};
		// 15 : oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`ASRA,rClear};  
		// 17 : oInstruc = {`NOP,rClear};
		// 18 : oInstruc = {`NOP,rClear};
		// 19: oInstruc = {`NOP,rClear};
		// 20 : oInstruc = {`ASRA,rClear};  
		// 21 : oInstruc = {`NOP,rClear};
		// 22 : oInstruc = {`NOP,rClear};
		// 23 : oInstruc = {`NOP,rClear};
		// 24 : oInstruc = {`ASRA,rClear};  
		// 25 : oInstruc = {`NOP,rClear};
		// 26 : oInstruc = {`NOP,rClear};
		// 27 : oInstruc = {`NOP,rClear};
		// 28 : oInstruc = {`ASRA,rClear};  
		// 29 : oInstruc = {`NOP,rClear};
		// 30 : oInstruc = {`NOP,rClear};
		// 31 : oInstruc = {`NOP,rClear};
		// 32 : oInstruc = {`ASRA,rClear};  
		// 33 : oInstruc = {`NOP,rClear};
		// 34 : oInstruc = {`NOP,rClear};
		// 35 : oInstruc = {`NOP,rClear};

// // Codigo de prueba de operaciones logicas AND y OR para A y B.
// 		0 : oInstruc = {`LDCA,2'b00,8'h0};  
//  		1 : oInstruc = {`NOP,rClear};
//  		2 : oInstruc = {`NOP,rClear};
// 		3 : oInstruc = {`LDCB,2'b00,8'hFF};  
// 		4 : oInstruc = {`ANDA,rClear};  
//  		5 : oInstruc = {`BAEQ,4'b0,6'b000010};
//  		6 : oInstruc = {`NOP,rClear};
//  		7 : oInstruc = {`NOP,rClear};
//  		8 : oInstruc = {`LDCB,2'b00,8'h1}; 
//  		9 : oInstruc = {`LDCB,2'b00,8'h7}; 

// // Loop de prueba de suma y branch hacia atras
// 		0 : oInstruc = {`ADDCA,2'b00,8'h1};  
// 		1 : oInstruc = {`NOP,rClear};
// 		2 : oInstruc = {`NOP,rClear};
// 		3 : oInstruc = {`BACC,4'b0,6'b100001};
// 		4 : oInstruc = {`NOP,rClear};
// 		5 : oInstruc = {`NOP,rClear};
// 		6: oInstruc = {`LDCB,2'b00,8'b1};	
    
       //0: oInstruc = {`LDCA,2'b00,8'h1};

       //1 : oInstruc = {`ADDA,rClear};

       //2: oInstruc = {`LDCA,2'b00,8'h7};
      // 1: oInstruc = {`LDCB,2'b00,8'h7};

      // 2: oInstruc = {`NOP,rClear};
	
      // 3: oInstruc = {`STA,10'h125};

      // 4: oInstruc = {`LDB,10'h125};

      // 5: oInstruc = {`NOP,rClear};

      // 6: oInstruc = {`NOP,rClear};
	
      // 7: oInstruc = {`ADDA,rClear};
     
      // 8: oInstruc = {`BACS,4'b0,6'd50};
      
      // 56: oInstruc = {`ADDB,rClear};

// Datos originales de aqui hacia abajo //
      // 0: oInstruc = {`LDCA,2'b00,8'h5};
      
      // 1: oInstruc = {`LDCB,2'b00,8'h7};

      // 2: oInstruc = {`NOP,rClear};

      // 3: oInstruc = {`NOP,rClear};

      // 4: oInstruc = {`ADDA,rClear};
      
      // 5: oInstruc = {`STB,10'h50};

      // 6: oInstruc = {`NOP,rClear};

      // 7: oInstruc = {`NOP,rClear};
      
      // 8: oInstruc = {`NOP,rClear};

      // 9: oInstruc = {`ADDA,rClear};

      // 10: oInstruc = {`ADDA,rClear};

      // //6: oInstruc = {`SUBB,rClear};

      // 11: oInstruc = {`NOP,10'h50};

      // 12: oInstruc = {`NOP,2'b00,8'h5};
    
      // 13: oInstruc = {`BBEQ,4'b0,6'd48};

      // 14: oInstruc = {`LDCA,2'b00,8'h60};
      
      // 55: oInstruc = {`LDCB,2'b00,8'h25};

      // 56: oInstruc = {`NOP,rClear};

      // 57: oInstruc = {`NOP,rClear};

      //------------------------------------------------------------------------------------------------
      //-----------  Caso para comprobar la correción de hazard de un load seguido de un store. --------
      //------------------------------------------------------------------------------------------------

      // 0: oInstruc = {`LDCA,2'b00,8'h15};

      // 1: oInstruc = {`STA,10'h50};

      // 2: oInstruc = {`LDCB,2'b00,8'h30};

      // 3: oInstruc = {`STB,10'h60};

      // 4: oInstruc = {`LDA,10'h60};

      // 5: oInstruc = {`LDB,10'h50};


      //------------------------------------------------------------------------------------------------
      //------------------------------------------------------------------------------------------------

      //------------------------------------------------------------------------------------------------
      //-----------  Caso para comprobar la correción de hazard de un operaciones consecutivas. --------
      //------------------------------------------------------------------------------------------------

      // 0: oInstruc = {`LDCA,2'b00,8'h5};

      // 1: oInstruc = {`LDCB,2'b00,8'h5};

      // 2: oInstruc = {`NOP,rClear};

      // 3: oInstruc = {`NOP,rClear};

      // 4: oInstruc = {`ADDA,rClear};

      // 5: oInstruc = {`ADDA,rClear};

      // 6: oInstruc = {`ADDA,rClear};

      // 7: oInstruc = {`ADDA,rClear};

      //------------------------------------------------------------------------------------------------
      //------------------------------------------------------------------------------------------------


      // 57: oInstruc = {`NOP,rClear};
     
      default: oInstruc = {`NOP,rClear};
    
    endcase
   
   end
  

endmodule




