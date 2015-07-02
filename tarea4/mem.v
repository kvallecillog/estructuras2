`include "ramDatos.v"

// Etapa de memoria del pipeline.
// Se utiliza con las instrucciones STXs,LDXs.


module mem(

	input wire memClk,
	input wire memReset,
	input wire [7:0] iAluDataEX,
	input wire [1:0] iOutMemSelect,
	input wire [9:0] iAddresReadNWrite,
	input wire [2:0] iControlAcum_EX,
	input wire [5:0] iInstr_EX,
	output [7:0] oDataToWB,
	output [2:0] oControlAcum_MEM

);

wire [7:0] oDataRamRead;

//--------------------------------------------------------------------------------------------------------
//Añadido para solucionar los hazards de load y store seguidos. Ya no se requieren NOPS entre ellos
//--------------------------------------------------------------------------------------------------------

wire [5:0] oldInstr_MEM;
wire [5:0] oldInstr_MEM_bar;
wire [7:0] oldDataToWB;
wire [7:0] oldDataToWB_bar;

wire memHazard;

regN #(6) regMemHazard (memClk,memReset,1,iInstr_EX,oldInstr_MEM,oldInstr_MEM_bar);
regN #(8) regDataToWBHazard (memClk,memReset,1,oDataToWB,oldDataToWB,oldDataToWB_bar);


assign memHazard = (((oldInstr_MEM == `LDA || oldInstr_MEM == `LDCA) && iInstr_EX == `STA) ||
					((oldInstr_MEM == `LDB || oldInstr_MEM == `LDCB ) && iInstr_EX == `STB)) ? 1:0;

wire [7:0] wDataMemIn;

assign wDataMemIn = (memHazard) ? oldDataToWB:iAluDataEX; 

//--------------------------------------------------------------------------------------------------------

// iOutMemSelect[1]: Si es 1 se escribe en memoria.
// iOutMemSelect[1]: Si es 0 se lee de memoria.
// iOutMemSelect[0]: Si es 1 se selecciona la memoria. 
// iOutMemSelect[0]: Si es 0 se selecciona la salida de la alu.

assign oControlAcum_MEM = iControlAcum_EX;

RAM_SINGLE_READ_PORT # (8,10,1024) DATA_MEM
(
.clk(memClk),
.memEnable(iOutMemSelect[0]),
.iWriteDataEnable( iOutMemSelect[1] ),
.iReadDataAddress( iAddresReadNWrite ),
.iWriteDataAddress(iAddresReadNWrite ),
.iDataMemIn( wDataMemIn),
.oDataMemOut( oDataRamRead )
);

assign oDataToWB = (iOutMemSelect[0])? oDataRamRead:iAluDataEX;

endmodule