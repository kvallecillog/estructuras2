
`timescale 1ns / 1ps
`define ESTADO_A 0
`define ESTADO_B 1
`define ESTADO_C 2

module FSM
(
	input wire Clock,
	input wire Reset,
	input wire In,
	output reg Out
);
	reg [1:0] CurrentState, NextState;
	reg NextOut; //Solo para hacer la salida sincrónica
	
	//Logica de Estado Presente y de Salida Sincrónica
	always @ ( posedge Clock, posedge Reset )

	begin
		if (Reset)
		
			begin
		
			CurrentState <= `ESTADO_A;
			Out <= 0;	
		
			end
			
		else

			begin
		
			CurrentState <= NextState;
			Out <= NextOut;	
		
			end
			
	end
	
	
	//Lógica de Próximo Estado de Máquina Moore (Salida solo depende del estado)
	always @ ( * )

	begin

		case (CurrentState)
			


			`ESTADO_A:
			begin
				NextOut = 0;
				if (In == 0)
					NextState = `ESTADO_B;
				else
					NextState = `ESTADO_B;
			end
			`ESTADO_B:
			begin
				NextOut = 1;
				if (In == 0)
					NextState = `ESTADO_A;
				else
					NextState = `ESTADO_C;
			end
			`ESTADO_C:
			begin
				NextOut = 0;
				if (In == 0)
					NextState = `ESTADO_B;
				else
					NextState = `ESTADO_C;
			end
			default:
			begin
				NextState = `ESTADO_A;
				NextOut = 0;
			end
		


		endcase

	end

endmodule
