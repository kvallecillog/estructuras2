`include "instrDefine.v"

// Constantes para el control de los acumuladores.
`define noLoad 3'b000
`define loadConstantA 3'b001
`define loadMemoryA 3'b010
`define loadConstantB 3'b011
`define loadMemoryB 3'b100


// Constantes para el control de los mux de la etapa EX.
`define selConstants 2'b00
`define selConstAAcumB 2'b01
`define selAcumAConstB 2'b10
`define selAcumAB 2'b11 



// ---------------------------------------------------------------------------------------------
module decoder(instr,newPC,constant,branchDir,branchTaken,outSelMux,controlAcum,operation);

	// Se define las entradas del modulo:
	// instr: Corresponde a la instruccion a decodificar.

	input wire [15:0] instr;
	input wire [9:0] newPC;
	
	// Se definen las salidas del modulo que decodifica las instrucciones.
	// 
	// - constant: Corresponde a la constante que va hacia los registros A y B.
	// - branchDir: Corresponde a la direccion a la que se debe dirigir el branch.
	// - branchTaken: Corresponde a la selección de un mux si tomar o no el branch.
	// - controlAcum: Corresponde a la señal de control del acumulador, la cual según la instruccion
	// 				  tiene como salidas los siguientes valores:
	//					- noLoad (000) : Implica que no se tiene que cargar ningún valor al acumulador.
	//					- loadConstantA (001):
	//					- loadConstantB (010):
	//					- loadMemoryA (011):
	//					- loadMemoryB (100):
	//
	// - outMuxSel: Señales de control del mux de la etapa de EX. Permite seleccionar entre el valor de los registros
	//				o la constante enviada como salida de este modulo como constant.
	// - operation: operacion que se debe realizar en la ALU.
	output wire [7:0] constant;
	output reg [9:0] branchDir;
	output reg branchTaken;
	output reg [1:0] outSelMux;
	output reg [2:0] controlAcum;
	output wire [5:0] operation; 
	
	assign operation = instrDecod;
	// Se descompone la instruccion en 2 registros:
	//
	// - instr_decod: Contiene el código de la instruccion a ejecutar.
	//	 se encuentra definido en el archivo XXXXX.V
	//
	// - instr_info : Contiene la información extra para ejecutar la instruccion.
	//   Como por ejemplo la posición de memoria a leer o guardar o constante a cargar.
	//
	wire [5:0] instrDecod;
	wire [9:0] instrInfo;
	assign instrDecod = instr[15:10];
	assign instrInfo = instr[9:0];
	
	// Se asignan variables más especificas para descompone la instruccion
	// 
	// - constant: Constante de 8 bits.
	// - saltoRel: Valor del salto relativo de la instrucción si es un branch
	//   son 5 bits de magnitud y el MSB para signo.
	//
	wire [5:0] saltoRel;
	assign constant = instrInfo [7:0];
	assign saltoRel = instrInfo [5:0];
	
	
	always @(*) begin
	
		// Si la instruccion es un JMP el mismo puede
		// direccionar toda la memoria, entonces 
		// en vez de utilizar un salto relativo se utiliza
		// un salto directo. 
		//
		// Ademas las instrucciones STA y STB tiene como información
		// adicional la direccion de memoria a la que debe guardar la
		// cual debe ser de 10 bits para direccionar cualquier posicion de memoria
		// por tanto este dato se pone en la señal branchDir, es importante destacar
		// que esto se realiza para maximizar el uso de recursos.
		if(instrDecod == `JMP || instrDecod == `STA || instrDecod == `STB) branchDir = instrInfo;
		// Para las otras instrucciones es relativo.
		else branchDir = newPC + saltoRel;
		
		
		case(instrDecod)
		
			`LDA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selConstants;
				
			end 
			
			`LDB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selConstants;
				
			end
			
			`LDCA: begin
			
				branchTaken = 0;
				controlAcum = `loadConstantA;
				outSelMux = `selConstants;
				
			end 
			
			`LDCB: begin
			
				branchTaken = 0;
				controlAcum = `loadConstantB;
				outSelMux = `selConstants;
				
			end
			
			`STA: begin
			
				branchTaken = 0;
				controlAcum = `noLoad;
				outSelMux = `selAcumAB;
				
			end
				
			`STB: begin
			
				branchTaken = 0;
				controlAcum = `noLoad;
				outSelMux = `selAcumAB;
				
			end
			
			// A <- (A)+(B)
			`ADDA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				
			end
			
			// B <- (A)+(B)
			`ADDB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				
			end
			
			// A <- (A) + CONST
			`ADDCA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				
			end
			
			// B <- (B) + CONST	
			`ADDCB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				
			end
			
			// A <- (A) - (B)
			`SUBA: begin
			
				branchTaken = 0;		
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				
			end	
			
			// B <- (A) - (B)
			`SUBB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				
			end
			
			// A <- (A) - CONST
			`SUBCA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				
			end
			
			// B <- (B) - CONST
			`SUBCB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				
			end
			
			// A <- (A) AND (B)
			`ANDA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				
			end
			
			// B <- (A) AND (B)
			`ANDB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				
			end
			
			// A <- (A) AND CONST	
			`ANDCA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				
			end
			
			// B <- (B) AND CONST
			`ANDCB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				
			end

			// A <- (A) OR (B)
			`ORA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				
			end
			
			// B <- (A) OR (B)
			`ORB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				
			end
				
			// A <- (A) OR CONST
			`ORCA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				
			end
			
			// B <- (B) OR CONST
			`ORCB: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				
			end

			// A <-  (C <- (A) <- 0)
			`ASLA: begin 
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				
			end
			
			// A <-  (0 <- (A) <- C)
			`ASRA: begin
			
				branchTaken = 0;
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				
			end
			
			
			`JMP: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BAEQ: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BANE: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BACS: begin 
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BACC:	begin 
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BAMI: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BAPL: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BBEQ: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BBNE: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BBCS: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BBCC: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BBMI: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
			`BBPL: begin
			
				branchTaken = 1;
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				
			end
			
		endcase
		
	end

endmodule


// ---------------------------------------------------------------------------------------------
// Modulo que funciona como los acumuladores A y B.
module acumAB(constant,data,control, salidaAcumA, salidaAcumB);

	// Entradas
	input [7:0] constant;
	input [7:0] data;
	input [2:0] control;
	
	// Salidas
	output reg [7:0] salidaAcumA;
	output reg [7:0] salidaAcumB;
	
	// Dependiendo del control se pone a la salida de los acumuladores el dato
	// que se solicitó según la instrucción.
	always @(control) begin

		case(control)
		
			`noLoad: begin 
			
				salidaAcumA = salidaAcumA;
				salidaAcumB = salidaAcumB;
				
			end
			
			`loadConstantA: begin
			
				salidaAcumA = constant;
				salidaAcumB = salidaAcumB;
				
			end
			
			`loadMemoryA: begin
				
				salidaAcumA = data;
				salidaAcumB = salidaAcumB;
				
			end
			
			`loadConstantB: begin 
			
				salidaAcumA = salidaAcumA;
				salidaAcumB = constant;
				
			end
			
			`loadMemoryB: begin 
			
				salidaAcumA = salidaAcumA;
				salidaAcumB = data;
				
			end
		
		endcase
	

	end
	
endmodule


// ----------------------------------------------------------------------------------------------------
// Se pegan los modulos de acumuladores y decodificador.
module id(data,instr,newPC,salidaAcumA,salidaAcumB,branchDir,branchTaken,outSelMux,operation);

	// Entradas.
	input [7:0] data;
	input [15:0] instr;
	input [9:0] newPC;
	
	
	// Salidas.
	output wire [7:0] salidaAcumA,salidaAcumB;
	output wire [9:0] branchDir;
	output wire branchTaken;
	output wire [1:0] outSelMux;
	output wire [5:0] operation;
	
	// Internas.
	wire [7:0] constant;
	wire [2:0] controlAcum;	
	
	
	acumAB acumuladores (constant,data,controlAcum, salidaAcumA, salidaAcumB);
	
	decoder decodificador(instr,newPC,constant,branchDir,branchTaken,outSelMux,controlAcum,operation);

endmodule