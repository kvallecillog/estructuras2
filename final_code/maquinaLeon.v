`timescale 1ns / 1ps

`define IDLE 0
`define CALC 1
`define DONE 2


module FSM (Clock,Reset,valid_data,ack,b_lsb,Out);

  // Señales de la FSM.
  input wire Clock, Reset;
  input wire valid_data, ack;
  
  // Señales del datapath.
  input wire b_lsb;
  
  // Salida de para el test bench.
  output reg [6:0] Out;

  // Señales internas de la máquina.
  reg a_sel, b_sel, prod_sel, add_sel, done_flag, enable, koala;
  
  // Señales de estados.
  reg [1:0] CurrentState, NextState;

  
  reg [5:0] cont;
  
  //Logica de Estado Presente y de Salida Sincrónica
  always @ ( posedge Clock, posedge Reset ) begin

    if (Reset) begin
    
      CurrentState <= `IDLE;
      Out <= 0;
      cont <= 0;
      
    end
    
    else begin
    
      
      CurrentState = NextState;
      
      Out = {a_sel, b_sel, prod_sel, add_sel, done_flag, enable, koala};
      
      if (CurrentState == `IDLE || CurrentState == `DONE) cont = 0;
      
      if (CurrentState == `CALC && a_sel) cont = cont + 1; 
      
    end
  end


  //Lógica de Próximo Estado de Máquina Moore (Salida solo depende del estado)
  always @ ( * ) begin
  
    if ((CurrentState == `IDLE && NextState == `CALC) 
	   || (CurrentState == `CALC && NextState == `CALC) ) enable = 1;
   
    else enable = 0;

    // ***********************************************************************
    // MORA ESTO ES LO QUE HACE QUE LA SEÑAL QUE UD PIDIÓ CAMBIE DE 0 A 1
    if (CurrentState == `IDLE && NextState == `CALC) koala = 1;
   
    else koala = 0;
    // ************************************************************************
    
    case (CurrentState)
      ////////////////////////////////////////
      `IDLE: begin
      
	a_sel <= 0;
	b_sel <= 0;
	prod_sel <= 0; 
	add_sel <= 0; 
	done_flag <= 0;
	
	// Mientras los datos sean invalidos, se mantiene en el estado inicial.
	if (valid_data == 0) begin
	
	  NextState <= `IDLE;
	  
	end
	
	// Si los datos se vuelven validos se pasa al estado de calculo.
	else begin
	
	  NextState <= `CALC;

	end
	  
      end
      
      /////////////////////////////////////////
      `CALC: begin
      
	// Se debe poner las señales de seleccion a 1 para seleccionar
	// en los muxes del datapath los datos shifted al final del datapath
	// y en el caso del prod_sel los datos resultantes del sumador.
	a_sel <= 1;
	b_sel <= 1;
	prod_sel <= 1; 
	done_flag <= 0;
	
	// Mientras el conteo se mantenga menor a 32 y el LSB de B
	// sea 1 se pone la señal de seleccion del mux de salida del sumador
	// a 1 para que eliga el resultado sumado. Además como la cuenta es
	// menor a 32 se continua calculando.
	if (cont < 32 && b_lsb) begin
	
	  add_sel <= 1;
	  NextState <= `CALC;
	
	end
	
	// Si la cuenta se mantiene menor a 32 y el LSB de B es 0 se pone
	// el selector del mux de salida del sumador a 1 para que eliga
	// el resultado sin sumar. Además como la cuenta es menor a 32 se continua
	// calculando.
	else if(cont < 32 && !b_lsb) begin
	
	  add_sel <= 0;
	  NextState <= `CALC;
	  
	end  
	
	// En caso de que la cuenta no sea mayor a 32 se pasa al estado DONE.
	// Además se deja pone add_sel a 0 para evitar que el resultado cambie.
	else begin
	
	  add_sel <= 0;
	  NextState <= `DONE;
	  
	end
	
      end
    ////////////////////////////////////////////////////////////////////
      `DONE:begin
	
	// Las señales de seleccion se pasan a 0 ya que no es necesario seguir
	// operando sobre los operandos.
	a_sel <= 0;
	b_sel <= 0;
	add_sel <= 0;
	// prod_sel se mantiene a 1 para mantener el resultado de la multiplicacion
	prod_sel <= 1; 
	
	done_flag <= 1;
     
	// Si ocurre un ACK significa que el dato ya fue entregado y por tanto
	// se puede regresar al estado inicial.
	if (ack) begin
	
	  NextState = `IDLE;
	  
	end
	  
	else begin
	
	  NextState = `DONE;
	  
	end
	  
      end

    /////////////////////////////////////////////////////////////////////////
      default: begin
    
	NextState = `IDLE;
      
      end
      
    endcase
    
  end
  
endmodule
