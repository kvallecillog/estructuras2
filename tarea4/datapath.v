`timescale 1ns / 1ps
`include "ramDatos.v"

module datapath
(
 input wire Clock,
 input wire Reset,
 output wire Signal 
);









//////////////////////////////////////////////////////////
// Modulo memoria de datos
//////////////////////////////////////////////////////////
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