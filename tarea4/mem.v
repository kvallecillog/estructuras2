`include "ramDatos.v"

// Etapa de memoria del pipeline.
// Se utiliza con las instrucciones STXs,LDXs.


module mem(

	input wire [7:0] iAluDataEX,
	input wire [1:0] iOutMemSelect,
	input wire [7:0] iDataWriteValue,
	input wire [9:0] iAddresReadNWrite,
	input wire [2:0] iControlAcum_EX,
	output [7:0] oDataToWB,
	output [2:0] oControlAcum_MEM

);

wire [7:0] oDataRamRead;


// iOutMemSelect[1]: Si es 1 se escribe en memoria.
// iOutMemSelect[1]: Si es 0 se lee de memoria.
// iOutMemSelect[0]: Si es 1 se selecciona la memoria. 
// iOutMemSelect[0]: Si es 0 se selecciona la salida de la alu.

assign oControlAcum_MEM = iControlAcum_EX;

RAM_SINGLE_READ_PORT # (8,10,1024) DATA_MEM
(
.iWriteDataEnable( iOutMemSelect[1] ),
.iReadDataAddress( iAddresReadNWrite ),
.iWriteDataAddress(iAddresReadNWrite ),
.iDataMemIn( iDataWriteValue),
.oDataMemOut( oDataRamRead )
);

assign oDataToWB = (iOutMemSelect[0])? iAluDataEX : oDataRamRead;

endmodule