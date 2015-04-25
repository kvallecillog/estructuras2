
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
// MODIFICAR, AUN NO TENGO EL OUTPUT DE LA MAQUINA.
	input wire in,
	output reg out,
// Se�ales del datapath
	input wire b_lsb,
	output reg a_sel,
	output reg b_sel,
	output reg prod_sel,
	output reg add_sel

);

	reg cont; 
	
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
			out <= 0;	
		
			end
			
		else

			begin
		
			CurrentState <= NextState;
			out <= NextOut;	
		
			end
			
	end
	
	
	//L�gica de Pr�ximo Estado de M�quina Moore (Salida solo depende del estado)
	
	always @ ( * )

	begin

		case (CurrentState)
			

			`IDLE:
			begin
				
				NextOut = 0; // LO TRAE POR DEFECTO EL CODIGO REVISAR!
				
				// Si valid_data es 0 mantengase en el estado IDLE.

				
				// En el estado IDLE la se�al prod_sel selecciona
				// el producto inicializado en 0.

				prod_sel = 0;

				// En el estado IDLE la se�al a_sel selecciona
				// el operando "a" inicial sin rotar.

				a_sel = 0;

				// En el estado IDLE la se�al a_sel selecciona
				// el operando "b" inicial sin rotar.

				b_sel = 0;


				if (valid_data == 0)

					NextState = `IDLE;
				
				// Si valid_data es 1 vaya al estado CALC.

				else

					NextState = `CALC;
				
				
			end
			

			`CALC:
			
			begin

				// lo traia por defecto el codigo, REVISAR.
				 NextOut = 1;


				// Cuando se ingresa al estado calcular el producto cambia respecto
				// a su valor inicial.

				prod_sel = 1;


				// En el estado CALC la se�al a_sel selecciona
				// el operando "a" que ya  ha sido rotado.

				a_sel = 1;

				// En el estado CALC la se�al a_sel selecciona
				// el operando "b" que ya ha sido rotado.

				b_sel = 1;




				if (cont < 32 && b_lsb == 1)
					
					begin

					NextState = `CALC;

					// Si el bit lsb de b era 1 sumo al producto a.
					add_sel = 1;

					cont = cont + 1;

					end
				
				// Se selecciona reg_prod mientras NO se cumpla b & 0x1 == 1:
				add_sel = 0;
				
				if (cont <32 && b_lsb == 0)
					
					begin
							
					NextState = `CALC;

					cont = cont + 1;

					end
				
				else 

					NextState = `DONE;

					cont = 0;
	
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
