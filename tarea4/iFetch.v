`include "instrDefine.v"

// ---------------------------------------------------------------------------------------------
module iFetch(clk,reset,iBr_dir,iBr_taken,oFetchedInst);

	// Se define las entradas del modulo IF:
	// - br_dir: direccion que se carga al pc cuando cuando un branch es tomado.
	// - br_taken: bit de seleccion para saber si cargar newPC o PC + 1
	input [`LENGTH_INSTR_MEM-1:0] iBr_dir;
	input iBr_taken;
	input reset;
	input clk;
	
	// Se definen las salidas del modulo IF.
	// - fetched_inst: direccion de 10 bits con los datos de la siguiente instruccion a decodificar
	output reg [`WIDTH_INSTR_MEM-1:0] oFetched_inst;
	output wire [`WIDTH_INSTR_MEM-1:0] oFetchedInst;
	
	// Internas
	wire [`LENGTH_INSTR_MEM-1:0] wPc_pointer;
	wire [`LENGTH_INSTR_MEM-1:0] wNew_pc;
	
	pc pcIF(clk,reset,iBr_dir,iBr_taken,wPc_pointer,wNew_pc);
	
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
    
      0: oInstruc = {`LDA,rClear};
      
      1: oInstruc = {`LDB,rClear};
	
      2: oInstruc = {`STA,rClear};
	
      3: oInstruc = {`ADDA,rClear};
      
      50: oInstruc = {`ADDB,rClear};
     
      default: oInstruc = {`NOP,rClear};
    
    endcase
   
   end
  

endmodule