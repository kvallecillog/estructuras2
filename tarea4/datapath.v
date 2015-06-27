`timescale 1ns / 1ps
`include "ramDatos.v"
`include "alu.v"
`include "tarea4.v"

module datapath
(
 input wire Clock,
 input wire Reset,
 output wire Signal 
);


// Datos de salida de la alu.
wire [7:0] oAluData;
wire [5:0] operation; // Alu instruction selection. operation.

alu aluEx 
(
	.Clock(Clock),
	.Reset(Reset),
	.iAluInstSel(operation),
	.oAluData(oAluData)
);



// Se reasignan las señales correspondientes a mem data
//assign wDataRamWrite = oAluData [7:0];
//assign wDataRamWrite = instrInfo [9:0];

//////////////////////////////////////////////////////////
// Modulo memoria de datos
//////////////////////////////////////////////////////////

// - rWriteDataEnable: Señal que proviene de la unidad de control que habilita la escritura en DATA_MEM
// - [9:0] wDataRamReadDes: Señal que proviene de la etapa ID y contiene la direccion a leer en DATA_MEM
// - [9:0] wDataRamWriteDes: Señal que proviene de la etapa ID y contiene la direccion a escribir en DATA_MEM
// - [7:0] wDataRamWrite: Señal que proviene de la etapa ID y contiene los datos a escribir en DATA_MEM
// - [7:0] wDataRamRead: Señal que sale de la etapa MEM y contiene los datos leidos de DATA_MEM


wire rWriteDataEnable;
wire [9:0] wDataRamReadDes;
wire [9:0] wDataRamWriteDes;
wire [7:0] wDataRamWrite; 
wire [7:0] wDataRamRead;


RAM_SINGLE_READ_PORT # (8,10,1024) DATA_MEM
(
.Clock( Clock ),
.iWriteDataEnable( rWriteDataEnable ),
.iReadDataAddress( wDataRamReadDes ),
.iWriteDataAddress( wDataRamWriteDes ),
.iDataMemIn( wDataRamWrite),
.oDataMemOut( wDataRamRead )
);
//////////////////////////////////////////////////////////


endmodule	