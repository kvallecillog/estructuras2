`timescale 1ns/1ps

`include "iFetch.v"
`include "id.v"

`define SIZE_REG(X,Y) X+Y  



module pipeline (clk,reset,wData_WB,/*wBrDir_IF,wBrTaken_IF,*/
  wAcumA_ID,wAcumB_ID,wBrDir_ID,wBrTaken_ID,wOutSelMux_ID,wOperation_ID);

  // Entradas 
  input clk,reset;
  

  //////////////////////////////////////////////////////////////////////////////
  wire [`WIDTH_INSTR_MEM-1:0] wFetchedInst_IF;
  wire [`LENGTH_INSTR_MEM-1:0] wNewPC_IF;
  //Entradas temporales!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  input [`WIDTH_DATA_MEM-1:0] wData_WB;
  wire [`LENGTH_INSTR_MEM-1:0] wBrDir_IF;
  wire wBrTaken_IF;
  
  assign wBrTaken_IF = wBrTaken_ID;
  assign wBrDir_IF = wBrDir_ID;
  
  iFetch etapa1 (.clk(clk),.reset(reset),.iBr_dir(wBrDir_IF),
    .iBr_taken(wBrTaken_IF),.oFetchedInst(wFetchedInst_IF),.oNew_pc(wNewPC_IF));
  //////////////////////////////////////////////////////////////////////////////
 
 
 
  ////////////////////////////////////////////////////////////////////////////////////////
   wire [`SIZE_REG(`LENGTH_INSTR_MEM,`WIDTH_INSTR_MEM)-1:0] inputReg_IF_ID; 
   assign inputReg_IF_ID = {wFetchedInst_IF,wNewPC_IF};
   
   
   wire [`SIZE_REG(`LENGTH_INSTR_MEM,`WIDTH_INSTR_MEM)-1:0] outReg_IF_ID;
   wire [`SIZE_REG(`LENGTH_INSTR_MEM,`WIDTH_INSTR_MEM)-1:0] outReg_IF_ID_bar;
   regN #(.size(`SIZE_REG(`LENGTH_INSTR_MEM,`WIDTH_INSTR_MEM))) registro_IF_ID (clk,reset,
    1,inputReg_IF_ID,outReg_IF_ID,outReg_IF_ID_bar);
   
   
   wire [`LENGTH_INSTR_MEM-1:0] outReg_IF_ID_NewPC;
   wire [`WIDTH_INSTR_MEM-1:0] outReg_IF_ID_FetchedInstr;
   assign {outReg_IF_ID_FetchedInstr,outReg_IF_ID_NewPC} = outReg_IF_ID;
  ////////////////////////////////////////////////////////////////////////////////////////
 
 
 

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Salidas temporales!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  output wire [`WIDTH_DATA_MEM-1:0] wAcumA_ID,wAcumB_ID;
  output wire [`LENGTH_INSTR_MEM-1:0] wBrDir_ID;
  output wire wBrTaken_ID;  
  output wire [1:0] wOutSelMux_ID;
  output wire [`OPERATION_SIZE-1:0] wOperation_ID; 
  output wire [`WIDTH_DATA_MEM-1:0] wConstant_ID;
  output wire [2:0] wControlAcum_ID;
  output wire wMemEnable_ID;

  id etapa2 (.data(wData_WB),.instr(outReg_IF_ID_FetchedInstr),.newPC(outReg_IF_ID_NewPC),.salidaAcumA(wAcumA_ID),
    .salidaAcumB(wAcumB_ID),.branchDir(wBrDir_ID),.branchTaken(wBrTaken_ID),.outSelMux(wOutSelMux_ID),
    .operation(wOperation_ID),.constant(wConstant_ID),.controlAcum(wControlAcum_ID),.memEnable(wMemEnable_ID));
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



 
 ex etapa3 (.iAcumA(), .iAcumB(),.iConst(),.outSelMuxExe(),
 	.iAluInstSel(),.branchDir_ID(),.branchTaken(),.branchDir_EX(),.oAluData());





 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



endmodule









`define SIZE_REG_DEF 32
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
// Modulo de registro de N bits.
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module regN(clk,clr,enable,in,out,out_bar);
	
	parameter size = `SIZE_REG_DEF;
	
	// Se tienen las entradas:
	// - in: el dato de entrada, un vector de SIZE bits.
	// - clk: reloj del registro.
	// - clr: reset del registro.
	// - out, out_bar: salidas del registro, son vectores de SIZE bits.
	input [size-1:0] in;
	input clk,clr,enable;
	output [size-1:0] out;
	output [size-1:0] out_bar;
	reg [size-1:0] out;
	reg [size-1:0] out_bar;
	
	// Se crea un bloque para definir la función que realiza un registro tipo PIPO (Parallel Input Parallel Output).
	// Si ocurre un flanco positivo del reloj y reset (clr) se encuentra a 0 se pasa el dato de entrada a la salida.
	always @(posedge clk) begin

		if (clr==0 && enable==1) begin 
		 
			out <= in;
			out_bar <= !in;
		
		end 
		
	end
	
	
	// Si ocurre un clr, la salida de los registros se vuelve 0 en q y 1 en q_bar.
	// REVISAR SI DEBE SER UN POSEDGE O POR NIVEL.
	always @(posedge clr) begin
	
		if (clr==1) begin 
		
			out <= 0; 
			out_bar<= 1; 
			
		end
	
	end 

endmodule