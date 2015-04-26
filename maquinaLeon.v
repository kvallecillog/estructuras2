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
  output reg [4:0] Out;

  // Señales internas de la máquina.
  reg a_sel, b_sel, prod_sel, add_sel, done_flag;
  
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
      Out = {a_sel, b_sel, prod_sel, add_sel, done_flag};
      
      if (CurrentState == `IDLE || CurrentState == `DONE) cont = 0;
      // REVISAR
      if (CurrentState == `CALC) cont = cont + 1; 
      
    end
  end


  //Lógica de Próximo Estado de Máquina Moore (Salida solo depende del estado)
  always @ ( * ) begin
  
    case (CurrentState)
      ////////////////////////////////////////
      `IDLE: begin
      
	a_sel <= 0;
	b_sel <= 0;
	prod_sel <= 0; 
	add_sel <= 0; 
	done_flag <= 0;
	
	if (valid_data == 0) begin
	
	  NextState <= `IDLE;
	  
	
	end
	
	else begin
	
	  NextState <= `CALC;
	  /*
	  a_sel <= 1;
	  b_sel <= 1;
	  prod_sel <= 1; 
	  add_sel <= 0; 
	  done_flag <= 0;
	  */
	end
	  
      end
      
      /////////////////////////////////////////
      `CALC: begin
	
	a_sel <= 1;
	b_sel <= 1;
	prod_sel <= 1; 
	done_flag <= 0;
	
	if (cont <= 32 && b_lsb) begin
	
	  add_sel <= 1;
	  NextState <= `CALC;
	
	end
	  
	else if(cont <= 32 && !b_lsb) begin
	
	  add_sel <= 0;
	  NextState <= `CALC;
	  
	end  
	
	else begin
	
	  add_sel <= 0;
	  NextState <= `DONE;
	  
	end
	
      end
    ////////////////////////////////////////////////////////////////////
      `DONE:begin
	
	a_sel <= 0;
	b_sel <= 0;
	prod_sel <= 1; 
	add_sel <= 0;
	done_flag <= 1;
     
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
