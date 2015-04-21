
`timescale 1ns / 1ps
`define IDLE 0
`define CALC 1
`define DONE 2

// FSM, maquina de estados finita

module FSM
(

// Se�ales de la FSM

	input wire Clock,
	input wire Reset,
	input wire valid_data,
	input wire ack,
	input wire In,
	output reg Out,

// Se�ales del datapath

	input wire b_lsb,
	output reg a_sel,
	output reg b_sel,
	output reg prod_sel,
	output reg add_sel

);


	// Registros de estado actual y proximo estado.

	reg [1:0] CurrentState, NextState;

	// Registro proxima salida

	reg NextOut; //Solo para hacer la salida sincr�nica
	

	//Logica de Estado Presente y de Salida Sincr�nica
	
	always @ ( posedge Clock, posedge Reset )

	begin
	
	// Si ocurre reset, coloque la maquina en el estado IDLE.

		if (Reset)

			begin
		
			CurrentState <= `IDLE;
			Out <= 0;	
		
			end
			
		else

			begin
		
			CurrentState <= NextState;
			Out <= NextOut;	
		
			end
			
	end
	
	
	//L�gica de Pr�ximo Estado de M�quina Moore (Salida solo depende del estado)
	
	always @ ( * )

	begin

		case (CurrentState)
			

			`IDLE:
			begin
				
				NextOut = 0;
				
				// Si valid_data es 0 mantengase en el estado IDLE.

				if (valid_data == 0)

					NextState = `IDLE;
				
				// Si valid_data es 1 vaya al estado CALC.

				else

					NextState = `CALC;
			end
			

			`CALC:
			
			begin

				NextOut = 1;

				if (In == 0)
					NextState = `IDLE;
				else
					NextState = `DONE;

			end
			


			`DONE:

			// El estado DONE envia el mensaje hacia afuera del multiplicador, 
			// el resultado se mantiene hasta que se reciba la se�al ack que indica que el resultado fue le�do.
			
			begin

				NextOut = 0;

				// Si ack es 0 mantengase en el estado DONE.
				
				if (ack == 0)
				
					NextState = `DONE;
				
				// Si ack es 1 vaya al estado IDLE.
				else
				
					NextState = `IDLE;

			end
			
			default:
			
			begin

				NextState = `IDLE;
				NextOut = 0;

			end
		

		endcase

	end

endmodule
