
`timescale 1ns / 1ps
`define IDLE 0
`define CALC 1
`define DONE 2

// FSM, maquina de estados finita

module FSM
(

// Señales de la FSM

	input wire Clock,
	input wire Reset,
	input wire valid_data,
	input wire ack,
	input wire In,
	output reg Out,

// Señales del datapath

	input wire b_lsb,
	input wire cont,
	output reg a_sel,
	output reg b_sel,
	output reg prod_sel,
	output reg add_sel,
	output reg cont_flag

);


	// Registros de estado actual y proximo estado.

	reg [1:0] CurrentState, NextState;

	// Registro proxima salida

	reg NextOut; //Solo para hacer la salida sincrónica
	

	//Logica de Estado Presente y de Salida Sincrónica
	
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
	
	
	//Lógica de Próximo Estado de Máquina Moore (Salida solo depende del estado)
	
	always @ ( * )

	begin

		case (CurrentState)
			

			`IDLE:
			begin
				
				//NextOut = 0;
				
				// Si valid_data es 0 mantengase en el estado IDLE.

				
				// En el estado IDLE la señal prod_sel selecciona
				// el producto inicializado en 0.

				prod_sel = 0;

				// En el estado IDLE la señal a_sel selecciona
				// el operando "a" inicial sin rotar.

				a_sel = 0;

				// En el estado IDLE la señal a_sel selecciona
				// el operando "b" inicial sin rotar.

				b_sel = 0;


				if (valid_data == 0)

					NextState = `IDLE;
				
				// Si valid_data es 1 vaya al estado CALC.

				else

					NextState = `CALC;
				
				
					//# Cuando entre por primera vez a calcular inicie 
					//# el contador de 32 bits.
					//# REVISAR!
				
					cont_flag=1;
			end
			

			`CALC:
			
			begin

				
				// NextOut = 1;


				// Cuando se ingresa al estado calcular el producto cambia respecto
				// a su valor inicial.

				prod_sel = 1;


				// En el estado CALC la señal a_sel selecciona
				// el operando "a" que ya  ha sido rotado.

				a_sel = 1;

				// En el estado CALC la señal a_sel selecciona
				// el operando "b" que ya ha sido rotado.

				b_sel = 1;


				if (cont < 32 && b_lsb == 1)

					NextState = `CALC;

					// Si el bit lsb de b era 1 sumo al producto a.
					add_sel = 1;

				if (cont <32 && b_lsb == 0)
					
					NextState = `CALC;

				else 

					NextState = `DONE;

					//# Cuando termine la cuenta baje la bandera del 
					//# contador de 32 bits.
					//# REVISAR!
					cont_flag=0;

			end
			


			`DONE:

			// El estado DONE envia el mensaje hacia afuera del multiplicador, 
			// el resultado se mantiene hasta que se reciba la señal ack que indica que el resultado fue leído.
			
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
