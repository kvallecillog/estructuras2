`include "instrDefine.v"

// ---------------------------------------------------------------------------------------------
module ifetch(br_dir, br_taken,reset,fetched_inst);

	// Se define las entradas del modulo IF:
	// - br_dir: direccion que se carga al pc cuando cuando un branch es tomado.
	// - br_taken: bit de seleccion para saber si cargar newPC o PC + 1

	input wire [9:0] br_dir;
	input wire br_taken;
	input wire reset;
	
	// Se definen las salidas del modulo IF.
	// - fetched_inst: direccion de 10 bits con los datos de la siguiente instruccion a decodificar

	output reg [9:0] fetched_inst;

	
endmodule


// ---------------------------------------------------------------------------------------------
// 
module pc(clk,br_dir,br_taken,pc_pointer,new_pc);

	// Entradas
	// - clk: señal que le indica al PC que debe de actualizar su valor
	// - br_dir: direccion calculada cuando se tomaría el branch
	// - br_taken: bit que se pone en uno si un branch debe de ser tomado

	input clk;
	input [9:0] br_dir;
	input br_taken;
	
	// Salidas
	// Salida del contador de programa. Es igual a pc_anterior + 1 o igual a br_dir dependiendo de si se tomó
	// o no se tomo el branch
	output reg [9:0] pc_pointer;
	output reg [9:0] new_pc;
	
	always @(clk posedge) begin

		if (br_taken) begin

		pc_pointer = br_dir;
		new_pc = br_dir + 1;
			
		end

		pc_pointer = pc_pointer + 1;
		new_pc = pc_pointer + 1;

	end
	
endmodule


// // ----------------------------------------------------------------------------------------------------
// // Se pegan los modulos de acumuladores y decodificador.
// module id(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux,operation);

// 	// Entradas.
// 	input [7:0] data;
// 	input [15:0] instr;
// 	input [9:0] newPC;
	
	
// 	// Salidas.
// 	output wire [7:0] salidaAcumA,salidaAcumB;
// 	output wire [9:0] branchDir;
// 	output wire branchTaken;
// 	output wire [1:0] outSelMux;
// 	output wire [5:0] operation;
	
// 	// Internas.
// 	wire [7:0] constant;
// 	wire [2:0] controlAcum;	
	
	
// 	acumAB acumuladores (constant,data,controlAcum, salidaAcumA, salidaAcumB);
	
// 	decoder decodificador(instr,newPC,constant,branchDir,branchTaken,outSelMux,controlAcum,operation);

// endmodule