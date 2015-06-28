`include "ramDatos.v"


module mem(

	input wire Clock,
	input wire [7:0] iAluDataEX,
	input wire rWriteDataEnable,
	input wire [9:0] wDataRamReadDes,
	input wire [9:0] wDataRamWriteDes,
	input wire [7:0] wDataRamWrite,
	output [7:0] wDataRamRead

);


RAM_SINGLE_READ_PORT # (8,10,1024) DATA_MEM
(
.Clock( Clock ),
.iWriteDataEnable( rWriteDataEnable ),
.iReadDataAddress( wDataRamReadDes ),
.iWriteDataAddress( wDataRamWriteDes ),
.iDataMemIn( wDataRamWrite),
.oDataMemOut( wDataRamRead )
);

endmodule