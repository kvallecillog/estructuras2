`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Memoria Ram para datos.
// Memoria con 1024 posiciones 
// ADDR_WIDTH = 10 bits, bits para indexarla.
// DATA_WIDTH = 8 bits por dato.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
module RAM_SINGLE_READ_PORT # ( parameter DATA_WIDTH= 8, parameter ADDR_WIDTH=10, parameter MEM_SIZE=1024 )
(
input wire clk,
input wire memEnable,
input wire iWriteDataEnable,
input wire[ADDR_WIDTH-1:0] iReadDataAddress,
input wire[ADDR_WIDTH-1:0] iWriteDataAddress,
input wire[DATA_WIDTH-1:0] iDataMemIn,
output reg [DATA_WIDTH-1:0] oDataMemOut
);

reg [DATA_WIDTH-1:0] Ram [MEM_SIZE:0];

	initial $readmemh("randomValuesRam.dat", Ram , 0, 1023); 

always @(posedge clk)
begin 

	if(memEnable)
	begin

		if (iWriteDataEnable) begin
		Ram[iWriteDataAddress] = iDataMemIn;
		oDataMemOut = oDataMemOut;
		end
		else 
		oDataMemOut = Ram[iReadDataAddress]; 	
	end
	else
	begin

		oDataMemOut = oDataMemOut;
		
	end
	
end 

endmodule

