`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Memoria Ram para datos.
// Memoria con 1024 posiciones 
// ADDR_WIDTH = 10 bits, bits para indexarla.
// DATA_WIDTH = 8 bits por dato.
////////////////////////////////////////////////////////////////////////////////////////////////////////////
module RAM_SINGLE_READ_PORT # ( parameter DATA_WIDTH= 8, parameter ADDR_WIDTH=10, parameter MEM_SIZE=1024 )
(
input wire Clock,
input wire iWriteEnable,
input wire[ADDR_WIDTH-1:0] iReadAddress,
input wire[ADDR_WIDTH-1:0] iWriteAddress,
input wire[DATA_WIDTH-1:0] iDataIn,
output reg [DATA_WIDTH-1:0] oDataOut
);

reg [DATA_WIDTH-1:0] Ram [MEM_SIZE:0];

always @(posedge Clock)
begin 

	if (iWriteEnable) 
	Ram[iWriteAddress] <= iDataIn; 
	oDataOut <= Ram[iReadAddress]; 
end 

endmodule