`timescale 1ns/1ps
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


// Constantes para la señal memControl
`define notEnableMem	2'b00
`define enableMemWrite	2'b01
`define enableMemRead	2'b11


// ---------------------------------------------------------------------------------------------
module decoder(instr,newPC,constant,branchDir,outSelMux,controlAcum,operation,memControl);

	// Se define las entradas del modulo:
	// instr: Corresponde a la instruccion a decodificar.

	input wire [15:0] instr;
	input wire [9:0] newPC;
	
	// Se definen las salidas del modulo que decodifica las instrucciones.
	// 
	// - constant: Corresponde a la constante que va hacia los registros A y B.
	// - branchDir: Corresponde a la direccion a la que se debe dirigir el branch.
	// - controlAcum: Corresponde a la señal de control del acumulador, la cual según la instruccion
	// 	tiene como salidas los siguientes valores:
	//	- noLoad (000) : Implica que no se tiene que cargar ningún valor al acumulador.
	//	- loadConstantA (001):
	//	- loadConstantB (010):
	//	- loadMemoryA (011):
	//	- loadMemoryB (100):
	//
	// - outMuxSel: Señales de control del mux de la etapa de EX. Permite seleccionar entre el valor de los registros
	//				o la constante enviada como salida de este modulo como constant.
	// - operation: operacion que se debe realizar en la ALU.
	// - memControl: habilitador para cargar el resultado de la ALU a memoria. Y decide si se escribe o no a la memoria.
	//    La parte baja indica si se debe escribir o no a la memoria y la parte alta indica si 
	output wire [7:0] constant;
	output reg [9:0] branchDir;
	output reg [1:0] outSelMux;
	output reg [2:0] controlAcum;
	output wire [5:0] operation; 
	output reg [1:0] memControl;
	
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
		if(instrDecod == `JMP || instrDecod == `STA || instrDecod == `STB 
			|| instrDecod == `LDA || instrDecod == `LDB) branchDir = instrInfo;
		// Para las otras instrucciones es relativo.
		else branchDir = newPC + {4'b0,saltoRel};
		
		
		case(instrDecod)
		
			`LDA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selConstants;
				memControl = `enableMemRead;

				
			end 
			
			`LDB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selConstants;
				memControl = `enableMemRead;

			end
			
			`LDCA: begin
			
				controlAcum = `loadConstantA;
				outSelMux = `selConstants;
				memControl = `notEnableMem;
				
			end 
			
			`LDCB: begin
			
				controlAcum = `loadConstantB;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`STA: begin
			
				controlAcum = `noLoad;
				outSelMux = `selAcumAB;
				memControl = `enableMemWrite;

			end
				
			`STB: begin
			
				controlAcum = `noLoad;
				outSelMux = `selAcumAB;
				memControl = `enableMemWrite;

			end
			
			// A <- (A)+(B)
			`ADDA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// B <- (A)+(B)
			`ADDB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// A <- (A) + CONST
			`ADDCA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				memControl = `notEnableMem;

			end
			
			// B <- (B) + CONST	
			`ADDCB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				memControl = `notEnableMem;

			end
			
			// A <- (A) - (B)
			`SUBA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;		//11
				memControl = `notEnableMem;

			end	
			
			// B <- (B) - (A)
			`SUBB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// A <- (A) - CONST
			`SUBCA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				memControl = `notEnableMem;

			end
			
			// B <- (B) - CONST
			`SUBCB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				memControl = `notEnableMem;

			end
			
			// A <- (A) AND (B)
			`ANDA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// B <- (A) AND (B)
			`ANDB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// A <- (A) AND CONST	
			`ANDCA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				memControl = `notEnableMem;

			end
			
			// B <- (B) AND CONST
			`ANDCB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				memControl = `notEnableMem;

			end

			// A <- (A) OR (B)
			`ORA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// B <- (A) OR (B)
			`ORB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
				
			// A <- (A) OR CONST
			`ORCA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAConstB;
				memControl = `notEnableMem;

			end
			
			// B <- (B) OR CONST
			`ORCB: begin
			
				controlAcum = `loadMemoryB;
				outSelMux = `selConstAAcumB;
				memControl = `notEnableMem;

			end

			// A <-  (C <- (A) <- 0)
			`ASLA: begin 
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			// A <-  (0 <- (A) <- C)
			`ASRA: begin
			
				controlAcum = `loadMemoryA;
				outSelMux = `selAcumAB;
				memControl = `notEnableMem;

			end
			
			
			`JMP: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BAEQ: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BANE: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BACS: begin 
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BACC:	begin 
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BAMI: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BAPL: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BBEQ: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BBNE: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BBCS: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BBCC: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BBMI: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`BBPL: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;

			end
			
			`NOP: begin
			
				controlAcum = `noLoad;
				outSelMux = `selConstants;
				memControl = `notEnableMem;
			
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
			
			
			default: begin
			
			  salidaAcumA = 0;
			  salidaAcumB = 0;
			  
			end
		
		endcase
	

	end
	
endmodule


// ----------------------------------------------------------------------------------------------------
// Se pegan los modulos de acumuladores y decodificador.
module id(data,instr,newPC,controlAcum_WB,salidaAcumA,salidaAcumB,branchDir,outSelMux, operation, constant, controlAcum_ID, memControl);

	// Entradas.
	input [7:0] data;
	input [15:0] instr;
	input [9:0] newPC;
	input [2:0] controlAcum_WB;
	
	// Salidas.
	output wire [7:0] salidaAcumA,salidaAcumB;
	output wire [9:0] branchDir;
	output wire [1:0] outSelMux;
	output wire [5:0] operation;
	output wire [7:0] constant;
	output wire [2:0] controlAcum_ID;	
	output wire [1:0] memControl;
	
	acumAB acumuladores (constant,data,controlAcum_WB, salidaAcumA, salidaAcumB);
	
	decoder decodificador(instr,newPC,constant,branchDir,outSelMux,controlAcum_ID,operation,memControl);

endmodule