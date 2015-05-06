`timescale 1ns/1ps


`define SIZE_REG 32
`define SIZE_MUX 32
`define SIZE_ADDER 64


//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo de registro de N bits.
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module regN(in,clk,clr/*,enable*/,out,out_bar);
	
	parameter size = `SIZE_REG;
	
	// Se tienen las entradas:
	// - in: el dato de entrada, un vector de 32 bits.
	// - clk: reloj del registro.
	// - clr: reset del registro.
	// - out, out_bar: salidas del registro, son vectores de 32 bits.
	input [size-1:0] in;
	input clk,clr;
	output [size-1:0] out;
	output [size-1:0] out_bar;
	reg [size-1:0] out;
	reg [size-1:0] out_bar;
	reg [size-1:0]clear;
	
	// Se crea un bloque para definir la función que realiza un registro tipo PIPO (Parallel Input Parallel Output).
	always @(posedge clk) begin

		if (clr==0 /*&& enable==1*/) begin 
		 
			out <= in;
			out_bar <= !in;
		
		end 
		
	end
	
	
	// Si ocurre un clr, la salida de los registros se vuelve 0 en q y 1 en q_bar.
	always @(posedge clr) begin
	
		clear = 0;
		
		if (clr==1) begin 
		
			out <= clear; 
			out_bar<= ~clear; 
			
		end
	
	end 

endmodule




//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Multiplexor 2N a N
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

module mux2NaN(select, d1,d2, q);

	parameter size = `SIZE_MUX;

	input select;
	output [size-1:0]q;
	reg [size-1:0] q;
	input [size-1:0] d1,d2;

	//Secuencia de selección de datos
	always @(*) begin

		case(select)
		
			0: q <= d1;
			1: q <= d2;
			
		endcase

	end
	
endmodule






//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo sumador de N bits
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

module adderN(in1,in2,out);

	parameter size = `SIZE_ADDER;

	output [size-1:0]out;
	reg [size-1:0] out;
	input [size-1:0] in1,in2;

	//Secuencia de selección de datos
	always @(*) begin

	  out = in1+in2;

	end
	
endmodule


//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Divisor de frecuencias
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module divisorFrecuencia(clkin,seleccion,enable,clka,clkout);
	
	input clkin;
	input [1:0] seleccion;
	input enable;

	output clkout,clka;
	reg clkout,clka;

	wire clkin;
	reg clkin2;
	reg clkin4;
	reg clkin8;
	reg clkin16;

	initial 
	begin
	clkout = 1'b0;
	clka = 0;
	clkin2 = 0;
	clkin4 = 0;
	clkin8 = 0;
	clkin16 = 0;
	end

	
	always @ (posedge clkin) 
	begin 
		clkin2 <= !clkin2; 
	end

	always @ (posedge clkin2) 
	begin 
		clkin4 <= !clkin4; 
	end

	always @ (posedge clkin4) 
	begin 
		clkin8 <= !clkin8; 
	end

	always @ (posedge clkin8) 
	begin 
		clkin16 <= !clkin16; 
	end

	always @(enable or clkin) begin  
	  if(!enable)
	  
	    clka = clkin;
	  
	    if(seleccion == 0)
	      
	      clkout <= clkin2;

	    if(seleccion == 1)
	    
	      clkout <= clkin4;
	      
	    if(seleccion == 2)
	    
	      clkout <= clkin8;
	    
	    if(seleccion == 3)
	    
	      clkout <= clkin16;
	  else
	      clkout = 1'b0;
	end

	
endmodule 


//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Reloj
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module reloj(enable,clkout);

	input enable;

	output clkout;
	reg clkout;
	
	reg clk;
	
	initial clk = 0;
	
	always #3.2 clk = ~clk;
	
	always @(*)
	begin 
		if(enable)
	
		clkout = clk;
		
		else 
		
		clkout = 1'b0;
	end
	
endmodule 