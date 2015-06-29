`include "instrDefine.v"


//Revisar la salida de la ALU en los BRANCHES y en JUMP


module alu(
 input wire [7:0] iAluOper1,
 input wire [7:0] iAluOper2,
 input wire [5:0] iAluInstSel,
 output reg branchTaken,
 output reg [7:0] oAluData // Resultado
);


	// Registros de estatus para los acumuladores A y B.
 	reg BCA; // Bandera de CARRY para el acumulador A.
 	reg BCB; // Bandera de CARRY para el acumulador B.
 	reg BAZ; // Bandera de ZERO para el acumulador B.
	reg BBZ; // Bandera de ZERO para el acumulador B.
 	reg BAN; // Bandera de NEGATIVE para el acumulador B.
 	reg BBN; // Bandera de NEGATIVE para el acumulador B.
 	
 	wire [5:0] sReg;

 	assign sReg = {BCA,BCB,BAZ,BBZ,BAN,BBN};


	always @(iAluInstSel,iAluOper1,iAluOper2) begin

	case(iAluInstSel) 
		
		
		`LDA: begin

			oAluData<=iAluOper1;
			BCA<=BCA 
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BAZ<=~|;iAluOper1 // sE afecta la bandera Z de A.	
			BBZ<=BBZ;		// Se mantiene la bandera C de A.
			BAN<=iAluOper1[7]; // sE afecta la bandera N de A.	
			BBN<=BBN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end

		
		`LDB: begin

			oAluData<=iAluOper2;
			BCA<=BCA 
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BBZ<=~|;iAluOper1 // sE afecta la bandera Z de A.	
			BAZ<=BAZ;		// Se mantiene la bandera C de A.
			BBN<=iAluOper1[7]; // sE afecta la bandera N de A.	
			BAN<=BAN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end


		`LDCA: begin

			oAluData<=iAluOper1;
			BCA<=BCA 
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BAZ<=~|;iAluOper1 // sE afecta la bandera Z de A.	
			BBZ<=BBZ;		// Se mantiene la bandera C de A.
			BAN<=iAluOper1[7]; // sE afecta la bandera N de A.	
			BBN<=BBN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end


				
		`LDCB: begin

			oAluData<=iAluOper2;
			BCA<=BCA 
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BBZ<=~|;iAluOper1 // sE afecta la bandera Z de A.	
			BAZ<=BBZ;		// Se mantiene la bandera C de A.
			BBN<=iAluOper1[7]; // sE afecta la bandera N de A.	
			BAN<=BBN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end


		`STA: begin

			oAluData<=0;
			BCA<=BCA 
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BAZ<=BAZ	
			BBZ<=BBZ;		// Se mantiene la bandera C de A.
			BAN<=BAN; 
			BBN<=BBN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end

		
		`STB: begin

			oAluData<=0;
			BCA<=BCA 
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BAZ<=BAZ	
			BBZ<=BBZ;		// Se mantiene la bandera C de A.
			BAN<=BAN; 
			BBN<=BBN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end


		//La operacion ADD es conmutativa sin embargo la afectacion de la bandera del carry es diferente para cada acumulador
		// por este motivo se separa para los casos A y B.

		`ADDA,`ADDCA: begin

			{BCA,oAluData}<=iAluOper1+iAluOper2;
			BCB<=BCB;		 // Se mantiene la bandera C de B.
			BAZ<=~|oAluData; // La suma afecta la bandera Z de A.	
			BBZ<=BBZ;		// Se mantiene la bandera C de A.
			BAN<=oAluData[7]; // La suma afecta la bandera N de A.	
			BBN<=BBN;		// Se mantiene la bandera N de B.
			branchTaken<=0;	 // No se toma el branch.		

		end

		`ADDB,`ADDCB: begin

			BCA<=BCA;
			{BCB,oAluData}<=iAluOper1+iAluOper2;
			BAZ<=BAZ;
			BBZ<=~|oAluData;
			BAN<=BAN;
			BBN<=oAluData[7];
 			branchTaken<=0;	

		end


		// La resta no es conmutativa. Se debe de separar por operandos y casos.
		// Se asume que el iAluOper1 contiene el acumulador A y el iAluOper2 contiene el acumulador B o la constante.
		`SUBA,`SUBCA: begin

	 		{BCA,oAluData}<=iAluOper1-iAluOper2;
			BCB<=BCB;
			BAZ<=~|oAluData;		
			BBZ<=BBZ;
			BAN<=oAluData[7];			
			BBN<=BBN;
			branchTaken<=0;	

		end

		// Se asume que el iAluOper1 contiene el acumulador A y el iAluOper2 contiene el acumulador B o la constante.
		`SUBB,`SUBCB: begin
		
			BCA<=BCA;
			{BCB,oAluData}<=iAluOper2-iAluOper1;
			BAZ<=BAZ;
			BBZ<=~|oAluData;
			BAN<=BAN;
			BBN<=oAluData[7];
			branchTaken<=0;	

		end

		
		`ANDA,`ANDCA: begin

			oAluData<=iAluOper1&iAluOper2;
			BCA<=BCA;
			BCB<=BCB;
			BAZ<=~|oAluData;
			BBZ<=BBZ;
			BAN<=oAluData[7];
			BBN<=BBN;
			branchTaken<=0;	

		end

		`ANDB,`ANDCB: begin

			oAluData<=iAluOper1&iAluOper2;
			BCA<=BCA;
			BCB<=BCB;
			BAZ<=BAZ;
			BBZ<=~|oAluData;
			BAN<=BAN;
			BBN<=oAluData[7];
 	 		branchTaken<=0;	
		
		end

		`ORA,`ORCA: begin

			oAluData<=iAluOper1|iAluOper2;
			BCA<=BCA;
			BCB<=BCB;
			BAZ<=~|oAluData;
 	 		BBZ<=BBZ;
			BAN<=oAluData[7];
			BBN<=BBN;
			branchTaken<=0;	

		end

		`ORB,`ORCB: begin

			oAluData<=iAluOper1|iAluOper2;
			BCA<=BCA;
			BCB<=BCB;
			BAZ<=BAZ;
			BBZ<=~|oAluData;
			BAN<=BAN;
			BBN<=oAluData[7];
     		branchTaken<=0;			
	
		end

		//Se asume que iAluOper1 contiene el acumulador A.

		`ASLA: begin
			
			oAluData<=iAluOper1>>1;	
		    BCA<=BCA;
			BCB<=BCB;
			BAZ<=~|oAluData;
			BBZ<=BBZ;
			BAN<=oAluData[7];
			BBN<=BBN;
			branchTaken<=0;	
		
		end

		`ASRA: begin

			oAluData<=iAluOper1<<1;
			BCA<=BCA;
			BCB<=BCB;
			BAZ<=~|oAluData;
			BBZ<=BBZ;
			BAN<=oAluData[7];	
			BBN<=BBN;
			branchTaken<=0;		

		end

		`JMP:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
		 	branchTaken<=1;
		 	oAluData<=0;        //Revisar si la salida de la ALU en branch o JMP va a cero o no

		end

		`BAEQ:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
		 	branchTaken<=BAZ;
		 	oAluData<=0;

		end

		`BANE:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
		 	branchTaken<=~BAZ;
		 	oAluData<=0;

		end

 	 	`BBEQ:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
		 	branchTaken<=BBZ;
		 	oAluData<=0;

		end
	
 	 	`BBNE:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
		 	branchTaken<=~BBZ;
		 	oAluData<=0;

		end
	
 	 	`BACS:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=BCA;
 	 		oAluData<=0;

		end

		`BACC:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=~BCA;
 	 		oAluData<=0;

		end

 	 	`BBCS:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=BCB;
 	 		oAluData<=0;

		end

		`BBCC:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=~BCB;
 	 		oAluData<=0;

		end

		 `BAMI:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=BAN;
 	 		oAluData<=0;

		end

		`BAPL:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=~BAN;
 	 		oAluData<=0;

		end

		`BBMI:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=BBN;
 	 		oAluData<=0;

		end

		`BBPL:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
 	 		branchTaken<=~BBN;
 	 		oAluData<=0;

		end
	
		default:begin

			BCA<=BCA;
			BCB<=BCB;
 	 		BAZ<=BAZ;
 	 		BBZ<=BBZ;
			BAN<=BAN;
			BBN<=BBN;
			branchTaken<=0;
			oAluData<=0;

		end

	endcase

	end

endmodule