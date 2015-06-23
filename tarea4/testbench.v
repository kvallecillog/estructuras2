`include "tarea4.v"

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
		// HAZARD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
	pegar pegado(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux, operation);

endmodule