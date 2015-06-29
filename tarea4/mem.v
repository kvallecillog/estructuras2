`include "ramDatos.v"


module mem(

	//input wire Clock,
	input wire [7:0] iAluDataEX,
	input wire [1:0] iOutMemSelect,
	input wire [7:0] iDataWriteValue,
	input wire [9:0] iAddresReadNWrite,
	output [7:0] oDataToWB

);

wire [7:0] oDataRamRead;




RAM_SINGLE_READ_PORT # (8,10,1024) DATA_MEM
(
//.Clock( Clock ),
.iWriteDataEnable( iOutMemSelect[0] ),
.iReadDataAddress( iAddresReadNWrite ),
.iWriteDataAddress(iAddresReadNWrite ),
.iDataMemIn( iDataWriteValue),
.oDataMemOut( oDataRamRead )
);

// always @(Clock ) begin
// 	if (iOutMemSelect[1]==1) begin

// 		oDataToWB<=oDataRamRead;

// 	end
// 	else if (iOutMemSelect[1]==0) begin

// 		oDataToWB<=iAluDataEX;
		
// 	end
// end

assign oDataToWB = (iOutMemSelect[1])? oDataRamRead:iAluDataEX;

endmodule