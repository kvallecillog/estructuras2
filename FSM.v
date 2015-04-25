	
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
// Señales del datapath
	input wire b_lsb,
	output reg a_sel,
	output reg b_sel,
	output reg prod_sel,
	output reg add_sel,
// Salida de para el test bench	
	output reg Done_Flag

);

	// contador de 6 bits para contar hasta 32.

	integer cont; 
	
	// Registros de estado actual y proximo estado.

	reg [1:0] CurrentState, NextState;

	reg a,b,c;

	always @(*)begin

		add_sel = b_lsb; 

	end

	// Registro proxima salida

	// reg NextOut; //Solo para hacer la salida sincrónica
	

	//Logica de Estado Presente y de Salida Sincrónica
	
	always @ ( posedge Clock, posedge Reset )

	begin
	
	// Si ocurre reset, coloque la maquina en el estado IDLE.

		if (Reset)

			begin
		
			CurrentState <= `IDLE;
		//	out <= 0;	
		
			end
			
		else

			begin
		
			CurrentState <= NextState;
		//	out <= NextOut;	
		
			end
			
	end
	
	
	//Lógica de Próximo Estado de Máquina Moore (Salida solo depende del estado)
	
	always @ ( posedge Clock )

	begin

		case (CurrentState)
			

			`IDLE:
			begin
				
			//	NextOut = 0; // LO TRAE POR DEFECTO EL CODIGO REVISAR!
				
				// Si valid_data es 0 mantengase en el estado IDLE.

				
				// En el estado IDLE la señal prod_sel selecciona
				// el producto inicializado en 0.

				prod_sel <= 0;

				// En el estado IDLE la señal a_sel selecciona
				// el operando "a" inicial sin rotar.

				a_sel <= 0;

				// En el estado IDLE la señal a_sel selecciona
				// el operando "b" inicial sin rotar.

				b_sel <= 0;
				a = 0;
				b= 0;
				c=0;

				// Inicializacion de contador.

				cont <= 0;


				// Se selecciona reg_prod mientras NO se cumpla b & 0x1 == 1:
				// add_sel <= 0;

				// Inicializacion de bandera done.
				Done_Flag <= 0 ;


				if (valid_data == 0)

					NextState <= `IDLE;
				
				// Si valid_data es 1 vaya al estado CALC.

				else

					NextState <= `CALC;
				
			end

			`CALC:
			
			begin

				// lo traia por defecto el codigo, REVISAR.
				//	 NextOut = 1;

				// Cuando se ingresa al estado calcular el producto cambia respecto
				// a su valor inicial.

				prod_sel <= 1;

				// En el estado CALC la señal a_sel selecciona
				// el operando "a" que ya  ha sido rotado.

				a_sel <= 1;

				// En el estado CALC la señal a_sel selecciona
				// el operando "b" que ya ha sido rotado.

				b_sel <= 1;

				// NextState = `CALC;
				if (cont < 32 && b_lsb == 1)
					
					begin

					a<=1;

					NextState <= `CALC;

					// Si el bit lsb de b era 1 sumo al producto a.
					// add_sel <= 1;

					cont <= cont + 1;

					end

				
				else if (cont <32 && b_lsb == 0)
					
					begin

					b=1;
							
					NextState <= `CALC;

					cont <= cont + 1;


					// Se selecciona reg_prod mientras NO se cumpla b & 0x1 == 1:
					// add_sel <= 0;

					end
				
				else 
					begin

					c= 1;
	
					NextState <= `DONE;

					// Se selecciona reg_prod mientras NO se cumpla b & 0x1 == 1:
					// add_sel <= 0;

					// Reinicio del contador.

					cont <= 0;

					end

	
			end
			
			`DONE:

			// El estado DONE envia el mensaje hacia afuera del multiplicador, 
			// el resultado se mantiene hasta que se reciba la señal ack que indica que el resultado fue leído.
			
			begin

			//	NextOut = 0;

			// Se selecciona reg_prod mientras NO se cumpla b & 0x1 == 1:
			// add_sel <= 0;

				// Si ack es 0 mantengase en el estado DONE.
				
				if (ack == 0)
					begin
					
					// Bandera que indica que el resultado esta listo.

					Done_Flag <= 1;

					NextState <= `DONE;

					end

				
				// Si ack es 1 vaya al estado IDLE.
				else
					
					begin

					// Bandera que indica que el resultado esta listo.
					
					Done_Flag <= 0;

					NextState <= `IDLE;

					end
			end
			
			default:
			
			begin

				NextState <= `IDLE;
			//	NextOut = 0;

			end
		

		endcase

	end

endmodule
