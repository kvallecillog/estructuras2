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



// Codigo de prueba de operaciones logicas AND y OR para A y B.
	// Prueba ANDA y BAEQ Prueba de salto.

	// 0 : oInstruc = {`LDCA,2'b00,8'hFF};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'h00};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ANDA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};
 	// 	12 : oInstruc = {`BAEQ,4'b0,6'd8};
 	// 	13: oInstruc = {`NOP,rClear};
 	// 	14: oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
 	// 	16: oInstruc = {`LDCB,2'b00,8'h1}; 
 	// 	17: oInstruc = {`NOP,rClear};
 	// 	18: oInstruc = {`NOP,rClear};
 	// 	19 : oInstruc = {`NOP,rClear};
 	// 	20: oInstruc = {`LDCB,2'b00,8'h7}; 

 	// Prueba ANDA y BAEQ Prueba de no salto.

 	// 	0 : oInstruc = {`LDCA,2'b00,8'hFF};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'h00};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ANDB,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};
 	// 	12 : oInstruc = {`BAEQ,4'b0,6'd8};
 	// 	13: oInstruc = {`NOP,rClear};
 	// 	14: oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
 	// 	16: oInstruc = {`LDCB,2'b00,8'h1}; 
 	// 	17: oInstruc = {`NOP,rClear};
 	// 	18: oInstruc = {`NOP,rClear};
 	// 	19 : oInstruc = {`NOP,rClear};
 	// 	20: oInstruc = {`LDCB,2'b00,8'h7}; 


 	//  	0 : oInstruc = {`LDCA,2'b00,8'd53};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'd83};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ANDA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};
 	// 	12 : oInstruc = {`SUBCA,2'b00,8'd17};
 	// 	13: oInstruc = {`NOP,rClear};
 	// 	14: oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
 	// 	16 : oInstruc = {`BAEQ,4'b0,6'd8};
 	// 	17: oInstruc = {`NOP,rClear};
 	// 	18: oInstruc = {`NOP,rClear};
 	// 	19 : oInstruc = {`NOP,rClear};
 	// 	20: oInstruc = {`LDCB,2'b00,8'h1}; 
 	// 	21: oInstruc = {`NOP,rClear};
 	// 	22: oInstruc = {`NOP,rClear};
 	// 	23 : oInstruc = {`NOP,rClear};
 	// 	24: oInstruc = {`LDCB,2'b00,8'h7}; 

 	 	0: oInstruc = {`LDCB,2'd0,8'H0};
		1: oInstruc = {`NOP,rClear};
		2: oInstruc = {`NOP,rClear};
		3: oInstruc = {`ADDB,2'd0,8'h1};  
		4: oInstruc = {`NOP,rClear};
		5: oInstruc = {`BBCC,4'b0,6'b100110};
 		6: oInstruc = {`LDCA,2'b00,8'H1};	



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



/*`timescale 1ns/1ps

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
 
// Memoria funciona! Dropbox
// Prueba de escritura, lectura y sobre carga de constante a los acumuladores.

  //       0: oInstruc = {`LDCA,2'b00,8'hff};
  //     	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
  //     	4: oInstruc = {`STA,10'd1}; 
 	// 	5 : oInstruc = {`NOP,rClear};
 	// 	6 : oInstruc = {`NOP,rClear};
 	// 	7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`LDA,10'd1};  
		// 9 : oInstruc = {`NOP,rClear};
		// 10 : oInstruc = {`NOP,rClear};
		// 11 : oInstruc = {`NOP,rClear};
		// 12: oInstruc = {`LDCB,2'b00,8'd00};
		// 13 : oInstruc = {`NOP,rClear};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`STB,10'd2};  
		// 17 : oInstruc = {`NOP,rClear};
 	// 	18: oInstruc = {`NOP,rClear};
 	// 	19 : oInstruc = {`NOP,rClear};
 	// 	20 : oInstruc = {`LDB,10'd2};
 	// 	21: oInstruc = {`NOP,rClear};
 	// 	22: oInstruc = {`NOP,rClear};
 	// 	23 : oInstruc = {`NOP,rClear};
 	// 	24 : oInstruc = {`SUBA,rClear}; 
 	// 	25: oInstruc = {`LDCA,2'b00,8'hff};
  //     	26 : oInstruc = {`NOP,rClear};
 	// 	27: oInstruc = {`NOP,rClear};
 	// 	28 : oInstruc = {`NOP,rClear};
  //     	29: oInstruc = {`STA,10'd1}; 
 	// 	30 : oInstruc = {`NOP,rClear};
 	// 	31 : oInstruc = {`NOP,rClear};
 	// 	32 : oInstruc = {`NOP,rClear};
		// 33 : oInstruc = {`LDA,10'd1};  
		// 34 : oInstruc = {`NOP,rClear};
		// 35 : oInstruc = {`NOP,rClear};
		// 36 : oInstruc = {`NOP,rClear};
		// 37: oInstruc = {`LDCB,2'b00,8'd00};
		// 38 : oInstruc = {`NOP,rClear};
 	// 	39 : oInstruc = {`NOP,rClear};
 	// 	40 : oInstruc = {`NOP,rClear};
		// 41 : oInstruc = {`STB,10'd2};  
		// 42 : oInstruc = {`NOP,rClear};
 	// 	43: oInstruc = {`NOP,rClear};
 	// 	44 : oInstruc = {`NOP,rClear};
 	// 	45 : oInstruc = {`LDB,10'd2};
 	// 	46: oInstruc = {`NOP,rClear};
 	// 	47: oInstruc = {`NOP,rClear};
 	// 	48 : oInstruc = {`NOP,rClear};
 	// 	49 : oInstruc = {`SUBA,rClear}; 

/// ESTA PRUEBA NO FUNCIONA 07:09 am 02/07/15
// // Prueba de ciclo no funciona!!
//  	// Loop de prueba de suma y branch hacia atras

// Se tiene problema con la señal branch taken

 	// 	0 : oInstruc = {`LDCB,2'd0,8'd1};
		// 1 : oInstruc = {`NOP,rClear};
		// 2 : oInstruc = {`NOP,rClear};
		// 3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCA,2'd0,8'd1};
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ADDA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
		// 10 : oInstruc = {`NOP,rClear};
		// 11 : oInstruc = {`NOP,rClear};
		// 12: oInstruc = {`BBCC,4'b0,6'b100100};
 	// 	13 : oInstruc = {`NOP,rClear};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15: oInstruc = {`LDCB,2'b00,8'HFF};	
 	// 	16 : oInstruc = {`NOP,rClear};
 	// 	17 : oInstruc = {`NOP,rClear};
 	// 	18: oInstruc = {`LDCB,2'b00,8'H00};	

// Prueba de ADDA y de la bandera BCA.

 	// 	0 : oInstruc = {`LDCB,2'd0,8'H0F};
		// 1 : oInstruc = {`NOP,rClear};
		// 2 : oInstruc = {`NOP,rClear};
		// 3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCA,2'd0,8'HF0};
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ADDA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
		// 10 : oInstruc = {`NOP,rClear};
		// 11 : oInstruc = {`NOP,rClear};
		// 12 : oInstruc = {`ADDA,rClear};  
		// 13: oInstruc = {`NOP,rClear};
		// 14 : oInstruc = {`NOP,rClear};
		// 15 : oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`LDCB,2'd0,8'd1};
		// 17: oInstruc = {`NOP,rClear};
		// 18: oInstruc = {`NOP,rClear};
		// 19: oInstruc = {`NOP,rClear};
		// 20: oInstruc = {`ADDA,rClear};  
		// 21: oInstruc = {`NOP,rClear};
		// 22 : oInstruc = {`NOP,rClear};
		// 23 : oInstruc = {`NOP,rClear};
		//Prueba ADDB
 	// 	24: oInstruc = {`LDCB,2'd0,8'H0F};
		// 25 : oInstruc = {`NOP,rClear};
		// 26: oInstruc = {`NOP,rClear};
		// 27: oInstruc = {`NOP,rClear};
		// 28: oInstruc = {`LDCA,2'd0,8'HF0};
		// 29: oInstruc = {`NOP,rClear};
		// 30: oInstruc = {`NOP,rClear};
		// 31: oInstruc = {`NOP,rClear};
		// 32: oInstruc = {`ADDB,rClear};  
		// 33: oInstruc = {`NOP,rClear};
		// 34 : oInstruc = {`NOP,rClear};
		// 35 : oInstruc = {`NOP,rClear};
		// 36 : oInstruc = {`ADDB,rClear};  
		// 37: oInstruc = {`NOP,rClear};
		// 38 : oInstruc = {`NOP,rClear};
		// 39 : oInstruc = {`NOP,rClear};
		// 40 : oInstruc = {`LDCA,2'd0,8'd1};
		// 41: oInstruc = {`NOP,rClear};
		// 42: oInstruc = {`NOP,rClear};
		// 43: oInstruc = {`NOP,rClear};
		// 44: oInstruc = {`ADDB,rClear};  
		// 45: oInstruc = {`NOP,rClear};
		// 46 : oInstruc = {`NOP,rClear};
		// 47 : oInstruc = {`NOP,rClear};


// //// REVISAAAAAAAAAR!!!!!!!
// ///// REVISARRRRRRRR!!!!!!!
// // Esta prueba no esta funcionando, 
// 		0: oInstruc = {`LDCB,2'd0,8'H0F};
// 		1 : oInstruc = {`NOP,rClear};
// 		2: oInstruc = {`NOP,rClear};
// 		3: oInstruc = {`NOP,rClear};
// 		4: oInstruc = {`LDCA,2'd0,8'HF0};
// 		5: oInstruc = {`NOP,rClear};
// 		6: oInstruc = {`NOP,rClear};
// 		7: oInstruc = {`NOP,rClear};
// 		8: oInstruc = {`ADDB,rClear};  
// 		9: oInstruc = {`NOP,rClear};
// 		10 : oInstruc = {`NOP,rClear};
// 		11 : oInstruc = {`NOP,rClear};
// 		12 : oInstruc = {`ADDB,rClear}; 
// 		// apartir de este nop se cambia el valor en el acumulador B, NO COMPRENDO. 
// 		13: oInstruc = {`NOP,rClear};
// 		14 : oInstruc = {`NOP,rClear};
// 		15 : oInstruc = {`NOP,rClear};
// 		16 : oInstruc = {`LDCA,2'd0,8'd1};
// 		17: oInstruc = {`NOP,rClear};
// 		18: oInstruc = {`NOP,rClear};
// 		19: oInstruc = {`NOP,rClear};
// 		20: oInstruc = {`ADDB,rClear};  
// 		21: oInstruc = {`NOP,rClear};
// 		22 : oInstruc = {`NOP,rClear};
// 		23 : oInstruc = {`NOP,rClear};

// Esta tampoco funciona por el branch hacia atras.
 	// 	0 : oInstruc = {`LDCA,2'd0,8'd0};
		// 1 : oInstruc = {`NOP,rClear};
		// 2 : oInstruc = {`NOP,rClear};
		// 3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`NOP,rClear};
		// 5 : oInstruc = {`ADDCA,2'd0,8'hFF};  
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`NOP,rClear};
		// 9 : oInstruc = {`ADDCA,2'd0,8'h1};  
		// 10 : oInstruc = {`NOP,rClear};
		// 11 : oInstruc = {`NOP,rClear};
		// 12 : oInstruc = {`NOP,rClear};
		// 13 : oInstruc = {`BBCC,4'b0,6'b000011};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
 	// 	16: oInstruc = {`LDCB,2'b00,8'HFF};	
		// 17 : oInstruc = {`NOP,rClear};
 	// 	18 : oInstruc = {`NOP,rClear};
 	// 	19: oInstruc = {`LDCB,2'b00,8'H11};	

 	// Prueba de SUBA y de la bandera BAZ.

 		0 : oInstruc = {`LDCB,2'd0,8'D15};
		1 : oInstruc = {`NOP,rClear};
		2 : oInstruc = {`NOP,rClear};
		3 : oInstruc = {`NOP,rClear};
		4 : oInstruc = {`LDCA,2'd0,8'D15};
		5 : oInstruc = {`NOP,rClear};
		6 : oInstruc = {`NOP,rClear};
		7 : oInstruc = {`NOP,rClear};
		8 : oInstruc = {`SUBA,rClear};  
		9 : oInstruc = {`NOP,rClear};
		10 : oInstruc = {`NOP,rClear};
		11 : oInstruc = {`NOP,rClear};
	

 
	// // Prueba ANDA FF 00 Y ANDB

		// 0 : oInstruc = {`LDCA,2'b00,8'hFF};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'h00};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ANDA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};
		// 12 : oInstruc = {`LDCA,2'b00,8'h00};  
 	// 	13 : oInstruc = {`NOP,rClear};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`LDCB,2'b00,8'hFF};  
		// 17: oInstruc = {`NOP,rClear};
		// 18 : oInstruc = {`NOP,rClear};
		// 19: oInstruc = {`NOP,rClear};
		// 20: oInstruc = {`ANDB,rClear};  
		// 21: oInstruc = {`NOP,rClear};
 	// 	22 : oInstruc = {`NOP,rClear};

	// // Prueba ANDA Y ANDB FF 00

		// 0 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ANDA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};	
		// 12 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 	// 	13: oInstruc = {`NOP,rClear};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15: oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		// 17: oInstruc = {`NOP,rClear};
		// 18: oInstruc = {`NOP,rClear};
		// 19 : oInstruc = {`NOP,rClear};
		// 20: oInstruc = {`ANDB,rClear};  
		// 21: oInstruc = {`NOP,rClear};
 	// 	22 : oInstruc = {`NOP,rClear};
 		// 23 : oInstruc = {`NOP,rClear};			
     

	// // Prueba ORA FF 00 Y ORB

		// 0 : oInstruc = {`LDCA,2'b00,8'hFF};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'h00};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ORA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};
		// 12 : oInstruc = {`LDCA,2'b00,8'hFF};  
 	// 	13 : oInstruc = {`NOP,rClear};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15 : oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`LDCB,2'b00,8'h00};  
		// 17: oInstruc = {`NOP,rClear};
		// 18 : oInstruc = {`NOP,rClear};
		// 19: oInstruc = {`NOP,rClear};
		// 20: oInstruc = {`ORB,rClear};  
		// 21: oInstruc = {`NOP,rClear};
 	// 	22 : oInstruc = {`NOP,rClear};

	// // Prueba ANDA Y ANDB TODOS LOS BITS CAMBIANDO

		// 0 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
		// 7 : oInstruc = {`NOP,rClear};
		// 8 : oInstruc = {`ORA,rClear};  
		// 9 : oInstruc = {`NOP,rClear};
 	// 	10 : oInstruc = {`NOP,rClear};
 	// 	11 : oInstruc = {`NOP,rClear};	
		// 12 : oInstruc = {`LDCA,2'b00,8'b00110101};  
 	// 	13: oInstruc = {`NOP,rClear};
 	// 	14 : oInstruc = {`NOP,rClear};
 	// 	15: oInstruc = {`NOP,rClear};
		// 16 : oInstruc = {`LDCB,2'b00,8'b01010011};  
		// 17: oInstruc = {`NOP,rClear};
		// 18: oInstruc = {`NOP,rClear};
		// 19 : oInstruc = {`NOP,rClear};
		// 20: oInstruc = {`ORB,rClear};  
		// 21: oInstruc = {`NOP,rClear};
 	// 	22 : oInstruc = {`NOP,rClear};
 	// 	23 : oInstruc = {`NOP,rClear};

		// // Prueba de ASLA

 	// 	0 : oInstruc = {`LDCA,2'b00,8'HFF};  
 	// 	1 : oInstruc = {`NOP,rClear};
 	// 	2 : oInstruc = {`NOP,rClear};
 	// 	3 : oInstruc = {`NOP,rClear};
		// 4 : oInstruc = {`ASLA,rClear};  
		// 5 : oInstruc = {`NOP,rClear};
		// 6 : oInstruc = {`NOP,rClear};
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


      default: oInstruc = {`NOP,rClear};
    
    endcase
   
   end
  

endmodule*/