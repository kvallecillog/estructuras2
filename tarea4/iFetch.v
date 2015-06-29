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
    
      // 0: oInstruc = {`LDCA,2'b00,8'h7};
      
      // 1: oInstruc = {`LDCB,2'b00,8'h7};

      // 2: oInstruc = {`NOP,rClear};
	
      // 3: oInstruc = {`STA,10'h125};

      // 4: oInstruc = {`LDB,10'h125};

      // 5: oInstruc = {`NOP,rClear};

      // 6: oInstruc = {`NOP,rClear};
	
      // 7: oInstruc = {`ADDA,rClear};
     
      // 8: oInstruc = {`BACS,4'b0,6'd50};
      
      // 56: oInstruc = {`ADDB,rClear};

      0: oInstruc = {`LDCA,2'b00,8'h7};
      
      1: oInstruc = {`LDCB,2'b00,8'h7};

      2: oInstruc = {`NOP,rClear};

      3: oInstruc = {`NOP,rClear};

      4: oInstruc = {`SUBB,rClear};
     
      5: oInstruc = {`BBEQ,4'b0,6'd48};
      
      55: oInstruc = {`LDCB,2'b00,8'h25};

      56: oInstruc = {`NOP,rClear};

      57: oInstruc = {`NOP,rClear};
     
      default: oInstruc = {`NOP,rClear};
    
    endcase
   
   end
  

endmodule