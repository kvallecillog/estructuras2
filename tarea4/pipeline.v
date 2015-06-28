`timescale 1ns/1ps

`include "iFetch.v"
`include "id.v"
`include "ex.v"

`define SIZE_REG(X,Y) X+Y  



module pipeline (clk,reset,wData_WB,wBrTaken_EX,wBrDir_EX,wAluResult_EX,
					wControlAcum_EX,wMemEnable_EX);

  // Entradas 
  input clk,reset;
  

  //////////////////////////////////////////////////////////////////////////////
  wire [`WIDTH_INSTR_MEM-1:0] wFetchedInst_IF;
  wire [`LENGTH_INSTR_MEM-1:0] wNewPC_IF;
  //Entradas temporales!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  input [`WIDTH_DATA_MEM-1:0] wData_WB;
  wire [`LENGTH_INSTR_MEM-1:0] wBrDir_IF;
  wire wBrTaken_IF;
  
  assign wBrTaken_IF = wBrTaken_EX;
  assign wBrDir_IF = wBrDir_EX;
  
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
  // 
  wire [`WIDTH_DATA_MEM-1:0] wAcumA_ID,wAcumB_ID;
  wire [`LENGTH_INSTR_MEM-1:0] wBrDir_ID;
  wire [1:0] wOutSelMux_ID;
  wire [`OPERATION_SIZE-1:0] wOperation_ID; 
  wire [`WIDTH_DATA_MEM-1:0] wConstant_ID;
  wire [2:0] wControlAcum_ID;
  wire wMemEnable_ID;

  id etapa2 (.data(wData_WB),.instr(outReg_IF_ID_FetchedInstr),.newPC(outReg_IF_ID_NewPC),.salidaAcumA(wAcumA_ID),
    .salidaAcumB(wAcumB_ID),.branchDir(wBrDir_ID),.outSelMux(wOutSelMux_ID),
    .operation(wOperation_ID),.constant(wConstant_ID),.controlAcum(wControlAcum_ID),.memEnable(wMemEnable_ID));
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 	// Tamaño del registro es  3*width + operation size + length + 1 + 3 + 2 
	wire [`SIZE_REG(`LENGTH_INSTR_MEM + 3 * `WIDTH_DATA_MEM, `OPERATION_SIZE + 6 )-1:0] inputReg_ID_EX; 
	assign inputReg_ID_EX = {wAcumA_ID,wAcumB_ID,wBrDir_ID,wOutSelMux_ID,wOperation_ID
							,wConstant_ID,wControlAcum_ID, wMemEnable_ID};
 
   
	wire [`SIZE_REG(`LENGTH_INSTR_MEM + 3 * `WIDTH_DATA_MEM, `OPERATION_SIZE + 6 )-1:0] outReg_ID_EX;
	wire [`SIZE_REG(`LENGTH_INSTR_MEM + 3 * `WIDTH_DATA_MEM, `OPERATION_SIZE + 6 )-1:0] outReg_ID_EX_bar;
	regN #(.size(`SIZE_REG(`LENGTH_INSTR_MEM + 3 * `WIDTH_DATA_MEM, `OPERATION_SIZE + 6 ))) registro_ID_EX (clk,reset,
    1,inputReg_ID_EX,outReg_ID_EX,outReg_ID_EX_bar);
   

	wire [`WIDTH_DATA_MEM-1:0] outReg_ID_EX_AcumA_ID,outReg_ID_EX_AcumB_ID;
	wire [`LENGTH_INSTR_MEM-1:0] outReg_ID_EX_BrDir_ID;
	wire [1:0] outReg_ID_EX_OutSelMux_ID;
	wire [`OPERATION_SIZE-1:0] outReg_ID_EX_Operation_ID; 
	wire [`WIDTH_DATA_MEM-1:0] outReg_ID_EX_Constant_ID;
	wire [2:0] outReg_ID_EX_ControlAcum_ID;
	wire outReg_ID_EX_MemEnable_ID;

   
   assign {outReg_ID_EX_AcumA_ID,outReg_ID_EX_AcumB_ID,outReg_ID_EX_BrDir_ID,
			outReg_ID_EX_OutSelMux_ID,outReg_ID_EX_Operation_ID,outReg_ID_EX_Constant_ID,
			outReg_ID_EX_ControlAcum_ID, outReg_ID_EX_MemEnable_ID} = outReg_ID_EX;
   
 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
	output wire wBrTaken_EX;
	output wire [`LENGTH_INSTR_MEM-1:0] wBrDir_EX;
	output wire [`WIDTH_DATA_MEM-1:0] wAluResult_EX;
	output wire [2:0] wControlAcum_EX;
	output wire wMemEnable_EX;

	ex etapa3 (.iAcumA(outReg_ID_EX_AcumA_ID), .iAcumB(outReg_ID_EX_AcumB_ID),.iConst(outReg_ID_EX_Constant_ID),
 		.outSelMuxExe(outReg_ID_EX_OutSelMux_ID),.iAluInstSel(outReg_ID_EX_Operation_ID),.branchDir_ID(outReg_ID_EX_BrDir_ID),
 		.branchTaken(wBrTaken_EX),.branchDir_EX(wBrDir_EX),.iMemEnable_ID(outReg_ID_EX_MemEnable_ID),
 		.iControlAcum_ID(outReg_ID_EX_ControlAcum_ID),.oAluData(wAluResult_EX),.oControlAcum_EX(wControlAcum_EX),.oMemEnable_EX(wMemEnable_EX));
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