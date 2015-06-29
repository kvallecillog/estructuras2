`timescale 1ns/1ps

`include "mem.v"

//PROBADOR DE LA ETAPA MEM.


module probador(

 	//output reg Clock,
	output reg [7:0] iAluDataEX,
	output reg [1:0] iOutMemSelect,
	output reg [7:0] iDataWriteValue,
	output reg [9:0] iAddresReadNWrite,
	input [7:0] oDataToWB

);

	// Internas
//	reg [9:0] clear = 0;

	initial begin
	
		$dumpfile("pruebaMEM.vcd");
		$dumpvars;


	//	Clock = 0;

		// Se esta escribiendo en la memoria el valor 7.
		iAluDataEX = 15;
		iOutMemSelect = 2'b01; // Salida de memoria
		iAddresReadNWrite=16'b1; // Posicion de memoria escrita
		iDataWriteValue = 7; // Valor escrito

		// Se esta leyendo de memoria la direccion escrita anteriormente
		#20 
		// Se esta escribiendo en la memoria el valor 7.
		iAluDataEX = 20;
		iOutMemSelect = 2'b10; // Salida de memoria
		iAddresReadNWrite=16'b1; // Posicion de memoria escrita
		iDataWriteValue = 7; // Valor escrito

		#20 $finish;
		
	end

		//always Clock = #10 ~Clock;

endmodule


module tester;

 //	wire Clock;
	wire [7:0] iAluDataEX;
	wire [1:0] iOutMemSelect;
	wire [7:0] iDataWriteValue;
	wire [9:0] iAddresReadNWrite;
	wire [7:0] oDataToWB;

	
	probador test(/*Clock,*/iAluDataEX,iOutMemSelect,iDataWriteValue,iAddresReadNWrite,oDataToWB);

	mem etapaMem(/*Clock,*/iAluDataEX,iOutMemSelect,iDataWriteValue,iAddresReadNWrite,oDataToWB);

endmodule