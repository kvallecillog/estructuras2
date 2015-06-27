`include "alu.v"


module ex(

 input wire iAcumA,	
 input wire iAcumB,
 input wire iConst,
 input wire [5:0] iAluInstSel,
 output [7:0] oAluData

);

reg [7:0] iAluOper1;
reg [7:0] iAluOper2;

wire zero,BCA,BCB;

always @(iAluInstSel,iAluOper1,iAluOper2) begin

// Este case asigna los operandos de entrada para la alu dependiendo de la instruccion a ejecutar.

case(iAluInstSel)

	`ADDA,`ADDB,`SUBA,`ANDA,`ANDB,`ORA,`ORB: begin
	iAluOper1<=iAcumA;
	iAluOper2<=iAcumB;	
	end

	`ADDCA,`SUBCA,`ANDCA,`ORCA: begin
	iAluOper1<=iAcumA;
	iAluOper2<=iConst;
	end

	`ADDCB,`SUBCB,`ANDCB,`ORCB:begin
	iAluOper1<=iConst;
	iAluOper2<=iAcumB;
	end

	`ASLA,`ASRA:begin
	iAluOper1<=iAcumA;
	end

	`BAEQ,`BANE:begin
	iAluOper1<=iAcumA;	
	end
	`BBEQ,`BBNE:begin
	iAluOper1<=iAcumB;	
	end

	default:begin
	iAluOper1<=iAcumA;
	iAluOper2<=iAcumB;	
	end

endcase

end

alu aluEx 
(
.iAluOper1(iAluOper1),
.iAluOper2(iAluOper2),
.iAluInstSel(iAluInstSel),
.zero(zero),
.BCA(BCA),
.BCB(BCB),
.oAluData(oAluData)
);

endmodule
