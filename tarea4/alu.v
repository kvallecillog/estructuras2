`include "instrDefine.v"


module alu(
 input wire [7:0] iAluOper1,
 input wire [7:0] iAluOper2,
 input wire [5:0] iAluInstSel,
 output zero,
 output reg BCA,
 output reg BCB,
 output reg [7:0] oAluData

);

	// 
//	assign  zero = (oAluData==0); // zero se levanta si la salida de la alu es 0. 
	
	// Registro que contiene la bandera de carry del acumulador A.
	//reg BCA;
	// Registro que contiene la bandera de carry del acumulador A.
	//reg BCB;

	always @(iAluInstSel,iAluOper1,iAluOper2) begin

	case(iAluInstSel) 
		
		
		//La operacion ADD es conmutativa sin embargo la afectacion de la bandera del carry es diferente para cada acumulador
		// por este motivo se separa para los casos A y B.

		`ADDA,`ADDCA: begin

		{BCA,oAluData}<=iAluOper1+iAluOper2;
			
		end

		`ADDB,`ADDCB: begin

		{BCB,oAluData}<=iAluOper1+iAluOper2;
			
		end

		// La resta no es conmutativa. Se debe de separar por operandos y casos.

		// Se asume que el iAluOper1 contiene el acumulador A y el iAluOper2 contiene el acumulador B o la constante.
		`SUBA,`SUBCA: begin
		
		{BCA,oAluData}<=iAluOper1-iAluOper2;

		end

		// Se asume que el iAluOper1 contiene el acumulador A y el iAluOper2 contiene el acumulador B o la constante.
		`SUBB,`SUBCB: begin
		
		{BCB,oAluData}<=iAluOper2-iAluOper1;

		end


		//La operacion OR es conmutativa no tiene problema con el orden de las entradas		
		
		`ANDA,`ANDB,`ANDCA,`ANDCB: begin
		oAluData<=iAluOper1&iAluOper2;
		end

		//La operacion OR es conmutativa no tiene problema con el orden de las entradas
		`ORA,`ORB,`ORCA,`ORCB: begin
		oAluData<=iAluOper1|iAluOper2;			
		end

		//Se asume que iAluOper1 contiene el acumulador A.

		`ASLA: begin
		oAluData<=iAluOper1>>1;	
		end

		`ASRA: begin
		oAluData<=iAluOper1<<1;		
		end

		// En ID se debe de definir que para el caso de los branches
		// se envian el resgistro correspondiente por el iAluOper1.	
		//CREO QUE ESTO DEBERIA DE REALIZARSE EN OTRA ETAPA, DEFINIENDO LA BANDERA BZ!
		
 		`BAEQ,`BBEQ,`BANE,`BBNE:begin
 		// Si se cumple que es igual a cero levante la bandera.
 		//xor bit a bit del iAluOper1 = acumulador.
	 	BAZ<=~|iAluOper1;
	 	BBZ<=~|iAluOper2;
		end
	

 		`BACS:begin
 		// Si se cumple que es igual a cero levante la bandera.
	 	BCA<=BCA;
		end
	
		`BACC:begin
		// Si se cumple que es diferente de cero levante la bandera.
	 	BCA<=~BCA;
		end	

 		`BBCS:begin
 		// Si se cumple que es igual a cero levante la bandera.
	 	BCB<=BCB;
		end
	
		`BBCC:begin
		// Si se cumple que es diferente de cero levante la bandera.
	 	BCB<=~BCB;
		end	

 		`BAMI,`BAPL:begin
 		// Si se cumple que es igual a cero levante la bandera.
	 	BNA<=iAluOper1[7];
		end

 		`BBMI,`BBPL:begin
 		// Si se cumple que es igual a cero levante la bandera.
	 	BNB<=iAluOper2[7];
		end

		default: oAluData<=0;

	endcase

	end

endmodule
/*
`define LDA 	6'h00
`define LDB 	6'h01
`define LDCA 	6'h02
`define LDCB 	6'h03
`define STA  	6'h04
`define STB  	6'h05
`define ADDA 	6'h06
`define ADDB 	6'h07
`define ADDCA	6'h08
`define ADDCB	6'h09
`define SUBA  	6'h0A
`define SUBB  	6'h0B
`define SUBCA 	6'h0C
`define SUBCB 	6'h0D
`define ANDA	6'h0E
`define ANDB 	6'h0F
`define ANDCA 	6'h10
`define ANDCB	6'h11
`define ORA		6'h12
`define ORB		6'h13
`define ORCA	6'h14
`define ORCB	6'h15
`define ASLA	6'h16
`define ASRA	6'h17
`define JMP		6'h18
`define BAEQ	6'h19
`define BANE	6'h1A
`define BACS	6'h1B
`define BACC	6'h1C
`define BAMI	6'h1D
`define BAPL	6'h1E
`define BBEQ	6'h1F
`define BBNE	6'h20
`define BBCS	6'h21
`define BBCC	6'h22
`define BBMI	6'h23
`define BBPL	6'h24*/