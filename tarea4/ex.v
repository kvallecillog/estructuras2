`include "alu.v"


module ex(

 input wire iAcumA,	
 input wire iAcumB,
 input wire iConst,
 output [7:0] oAluData

);

reg [7:0] iAluOper1;
 reg [7:0] iAluOper2;
 wire [5:0] iAluInstSel;
 // output zero,
 //output reg BCA,
 //output reg BCB,
wire zero,BCA,BCB;

always @(iAluInstSel,iAluOper1,iAluOper2) begin

case(iAluInstSel)

	`ADDA,`SUBA: begin
	iAluOper1<=iAcumA;
	iAluOper2<=iAcumB;	
	end
	`ADDCA,`SUBCA: begin
	iAluOper1<=iAcumA;
	iAluOper2<=iConst;
	end

	`ADDCB,`SUBCB:begin
	iAluOper1<=iConst;
	iAluOper2<=iAcumB;
	end


	`ADDA,`SUBA: begin
	iAluOper1<=iAcumA;
	iAluOper2<=iAcumB;	
	end
	`ADDCA,`SUBCA: begin
	iAluOper1<=iAcumA;
	iAluOper2<=iConst;
	end

	`ADDCB,`SUBCB:begin
	iAluOper1<=iConst;
	iAluOper2<=iAcumB;
	end

	`ANDA,`ANDB:begin
	iAluOper1<=iAcumA;
	iAluOper2<=iAcumB;
	end

	`ANDCA:begin
	iAluOper1<=iAcumA;
	iAluOper2<=iConst;
	end

	`ANDCB:begin
	iAluOper1<=iConst;
	iAluOper2<=iAcumB;
	end

	`ORA,`ORB:begin
	iAluOper1<=iAcumA;
	iAluOper2<=iAcumB;
	end

	`ORCA:begin
	iAluOper1<=iAcumA;
	iAluOper2<=iConst;
	end

	`ORCB:begin
	iAluOper1<=iConst;
	iAluOper2<=iAcumB;
	end

	`ASLA,`ASRA:begin
	iAluOper1<=iAcumA;
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
