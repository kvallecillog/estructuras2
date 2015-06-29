`timescale 1ns/1ps

`include "mem.v"

//PROBADOR DE LA ETAPA MEM.


module probador(

 	//output reg Clock,
	output reg [7:0] iAluDataEX,
	output reg [1:0] iOutMemSelect,
	output reg [9:0] iAddresReadNWrite,
	output reg [2:0] iControlAcum_EX,
	input [7:0] oDataToWB,
	input [2:0] oControlAcum_MEM
);

	// Internas
//	reg [9:0] clear = 0;

	initial begin
	
			$dumpfile("prueba2mem.vcd");
		$dumpvars;


	//	Clock = 0;

		// Se esta escribiendo en la memoria el valor 15.
		iAluDataEX = 9;
		iOutMemSelect = 3; // Salida de memoria
		iAddresReadNWrite=16'b1; // Posicion de memoria escrita
		//iDataWriteValue = 12; // Valor escrito

		// Se esta leyendo de memoria la direccion escrita anteriormente
		#20 

		// Se esta escribiendo en la memoria el valor 15.
		iAluDataEX = 8;
		iOutMemSelect = 3; // Salida de memoria
		iAddresReadNWrite=16'b1; // Posicion de memoria escrita
		//iDataWriteValue = 12; // Valor escrito

		// Se esta leyendo de memoria la direccion escrita anteriormente
		#20 
		// Se esta escribiendo en la memoria el valor 7.
		iAluDataEX = 15;
		iOutMemSelect = 3; // Salida de memoria
		iAddresReadNWrite=16'b10; // Posicion de memoria escrita
		//iDataWriteValue = 0; // Valor escrito
		#20 

		// Se esta escribiendo en la memoria el valor 15.
		iAluDataEX = 15;
		iOutMemSelect = 1; // Salida de memoria
		iAddresReadNWrite=16'b1; // Posicion de memoria escrita
		//iDataWriteValue = 12; // Valor escrito

		// Se esta leyendo de memoria la direccion escrita anteriormente
		#20 
		// Se esta escribiendo en la memoria el valor 7.
		iAluDataEX = 7;
		iOutMemSelect = 1; // Salida de memoria
		iAddresReadNWrite=16'b10; // Posicion de memoria escrita
		//iDataWriteValue = 0; // Valor escrito
		#20 $finish;
		
	end

		//always Clock = #10 ~Clock;

endmodule


module tester;

 //	wire Clock;
	wire [7:0] iAluDataEX;
	wire [1:0] iOutMemSelect;
	wire [9:0] iAddresReadNWrite;
	wire [2:0] iControlAcum_EX;
	wire [7:0] oDataToWB;
	wire [2:0] oControlAcum_MEM;

	
	probador test(iAluDataEX,iOutMemSelect,iAddresReadNWrite,iControlAcum_EX,oDataToWB,oControlAcum_MEM);

	mem etapaMem(iAluDataEX,iOutMemSelect,iAddresReadNWrite,iControlAcum_EX,oDataToWB,oControlAcum_MEM);

endmodule