`timescale 1ns/1ps

// Se definen los retardos de las compuertas.
`define TCOMPEqual 0
`define TCOMPmay_me 0
`define Tcont 0
`define TcontRst 0 
`define Treg 0
`define TregRst 0
`define TFF 0
`define TFFrst 0
`define DATA_BUS 32
`define Tand 0
`define Tor 0
`define Tnor 0
`define Tinv 0
`define Tmux2 0
`define Tmux8 1
`define Tdemux 1
`define Tbuf 0

// Se definen los tiempos de set up y hold para los componentes síncronos.
`define TsetupFF 0
`define TholdFF 0
`define TsetupReg 0
`define TholdReg 0
`define TsetuppE 0
`define TholdpE 0
`define TsetupcE 0
`define TholdcE 0


//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo And
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module kand(out, a, b);

	input a,b;
	output out;
	reg out;

	always @(a or b) begin
		
		out = #`Tand  a&b;
	end

	
endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Or
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module kor(out, a, b);

	input a,b;
	output out;
	reg out;

	always @(a or b) begin
		
		out = #`Tor  a|b;
	end
		
endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Nor de 4 entradas
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module knor4 (out,a,b,c,d);

	input a,b,c,d;
	output out;
	reg out;

	always @(a or b or c or d) begin
	
		out = #`Tnor !(a|b|c|d);
	
	end
	
endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Not (Inversor)
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module knot(out,a);

	input a;
	output out;
	reg out;

	always @(a) begin

		out = #`Tinv !a;

	end
		
endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Buffer
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module kbuf(out,a);

	input a;
	output out;
	reg out;

	always @(a) begin

		out = #`Tbuf a;

	end
		
endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Contador de 8 bits
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module cont8bits(clk,rst,pE,cE,load,cuenta);

	// Entradas: 
	// - clk: reloj del contador.
	// - rst: reset del contador, al recibir un pulso en esta entrada, la salida se pone a 0.
	// - pE: parallel enable: si esta entrada esta en bajo y ocurre un posedge de clk, se transfiere load a la salida del contador.
	// -cE: chip enable, cuando está en bajo el contador funciona con normalidad, si está en 1 mantiene la cuenta actual.
	// -load: carga en paralelo.
	// Salida:
	// - cuenta: el valor de salida de la cuenta, entre 0 y 63 en binario.
	input clk,rst,pE,cE;
	input [7:0] load;
	output [7:0] cuenta;
	reg [7:0] cuenta;
	
	// Siempre que haya un posedge del clk y cE esté a cero si pE está a 1 la cuenta aumenta en 1, de lo contrario pasa a ser la carga en paralelo.
	always @ (posedge clk) begin

		if (cE==0) begin

			if (pE==1) cuenta = #`Tcont cuenta+1;
			if (pE==0) cuenta = #`Tcont load;

		end
		
	end
	
	// Se tiene un reset síncrono.
	always @(posedge rst) if (rst==1) cuenta = #`TcontRst 8'b0;

endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo de registro de 32 bits.
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module reg32(in,clk,clr,out,out_bar);
	
	// Se tienen las entradas:
	// - in: el dato de entrada, un vector de 32 bits.
	// - clk: reloj del registro.
	// - clr: reset del registro.
	// - out, out_bar: salidas del registro, son vectores de 32 bits.
	input [31:0] in;
	input clk,clr;
	output [31:0] out;
	output [31:0] out_bar;
	reg [31:0] out;
	reg [31:0] out_bar;
	
	// Se crea un bloque para definir la función que realiza un registro tipo PIPO (Parallel Input Parallel Output).
	always @(posedge clk) begin

		if (clr==0) begin 
		 
			out <= #`Treg in;
			out_bar <= #`Treg !in;
		
		end 
		
	end
	
	
	// Si ocurre un clr, la salida de los registros se vuelve 0 en q y 1 en q_bar.
	always @(posedge clr) begin
	
		if (clr==1) begin 
			out <= #`TregRst 32'b0; 
			out_bar<= #`TregRst 32'b1; 
		end
	
	end 

endmodule



//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo de registro de 64 bits.
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module reg64(in,clk,clr,out,out_bar);
	
	// Se tienen las entradas:
	// - in: el dato de entrada, un vector de 64 bits.
	// - clk: reloj del registro.
	// - clr: reset del registro.
	// - out, out_bar: salidas del registro, son vectores de 64 bits.
	input [63:0] in;
	input clk,clr;
	output [63:0] out;
	output [63:0] out_bar;
	reg [63:0] out;
	reg [63:0] out_bar;
	
	// Se crea un bloque para definir la función que realiza un registro tipo PIPO (Parallel Input Parallel Output).
	always @(posedge clk) begin

		if (clr==0) begin 
		 
			out <= #`Treg in;
			out_bar <= #`Treg !in;
		
		end 
		
	end
	
	
	// Si ocurre un clr, la salida de los registros se vuelve 0 en q y 1 en q_bar.
	always @(posedge clr) begin
	
		if (clr==1) begin 
			out <= #`TregRst 64'b0; 
			out_bar<= #`TregRst 64'b1; 
		end
	
	end 

endmodule



//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Multiplexor 64a32
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

module mux64a32( select, d1,d2, q);

	input select;
	output [31:0]q;
	reg [31:0] q;
	input [31:0] d1,d2;

	//Secuencia de selección de datos
	always @(*) begin

		case(select)
		
			0: q <= #`Tmux8 d1;
			1: q <= #`Tmux8 d2;
			
		endcase

	end
	
endmodule




//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Multiplexor 128a64
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

module mux128a64( select, d1,d2, q);

	input select;
	output [63:0]q;
	reg [63:0] q;
	input [63:0] d1,d2;

	//Secuencia de selección de datos
	always @(*) begin

		case(select)
		
			0: q <= #`Tmux8 d1;
			1: q <= #`Tmux8 d2;
			
		endcase

	end
	
endmodule



//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo sumador de 64 bits
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------

module adder64(in1,in2,out);

	output [63:0]out;
	reg [63:0] out;
	input [63:0] in1,in2;

	//Secuencia de selección de datos
	always @(*) begin

		out = in1+in2;

	end
	
endmodule

//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Flip Flop tipo D
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module ffd(d,clk,clr,q,q_bar);
	
	input d,clk,clr;
	output q, q_bar;
	reg q,q_bar;
	wire notifyff;
		
	// Se crea un bloque para definir la función que realiza un FF tipo D, note que también se agregan los retardos de propagación del FF comercial escogido.
	always @(posedge clk) begin

		if (clr==0) begin 
		 
			q <= #`TFF d;
			q_bar <= #`TFF !d;
		
		end 
		
	end
	
	// Se tiene un reset asíncrono, que pone en 0 q y en 1 q_bar.
	always @(posedge clr) begin
	
		if (clr==1) begin 
		
			q <= #`TFFrst 0; 
			q_bar <= # `TFFrst 1;
		end
	
	end
	
endmodule 



//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Comparador de 9 bits
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module comp9bits(data1,data2,iguales9,mayor91,mayor92);
	
	// Entradas:
	// - data1,data2: Vectores de 9 bits a comparar.
	// Salidas:
	// - iguales9: Indica si ambos vectores son iguales, si está en 0, son iguales de lo contrario no lo son.
	// - mayor91: Indica con un 1 lógico si el data1 es mayor a data2.
	// - mayor92: Indica con un 1 lógico si el data2 es mayor a data1.
	input [8:0] data1;
	input [8:0] data2;
	output iguales9,mayor91,mayor92;
	reg	iguales9,mayor91,mayor92;

	// Siempre que cambien algún vector de datos, se comparan ambos.
	always @(*) begin
	
		if (data1==data2) begin
	
			iguales9<= #`TCOMPEqual 0;
			mayor91<= #`TCOMPmay_me 0;
			mayor92<= #`TCOMPmay_me 0;
			
		end
		
		if (data1>data2) begin
	
			iguales9<= #`TCOMPEqual 1;
			mayor91<= #`TCOMPmay_me 1;
			mayor92<= #`TCOMPmay_me 0;
			
		end
		
		if (data1<data2) begin
	
			iguales9<= #`TCOMPEqual 1;
			mayor91<= #`TCOMPmay_me 0;
			mayor92<= #`TCOMPmay_me 1;
			
		end		
		
	end
	
endmodule



//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Multiplexor 2a1
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module mux2a1(s0,d0,d1,q);

	//Entradas del Multiplexor
	input s0, d0, d1;

	//Salida del Multiplexor
	output q;

	//Memoria del Multiplexor (Verilog)
	reg q;

	always @(*) begin
	    if(s0 == 0)
	      
	      q <= #`Tmux2 d0;

	    if(s0 == 1)
	    
	      q <= #`Tmux2 d1;
	 
	end
	
endmodule



//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
//Modulo Demultiplexor 8a1
//------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------
module demux8a1(select,d,q); 

	// Las entradas son:
	input d; 
	input [2:0] select; 
	output [7:0] q;
	reg [7:0] q; 

	// Se selecciona la salida del demultiplexor
	always@(*) begin 
	
		case (select)
			4'b000 : q <= #`Tdemux {7'b0,d};
			4'b001 : q <= #`Tdemux {6'b0,d,1'b0};
			4'b010 : q <= #`Tdemux {5'b0,d,2'b0};
			4'b011 : q <= #`Tdemux {4'b0,d,3'b0};
			4'b100 : q <= #`Tdemux {3'b0,d,4'b0};
			4'b101 : q <= #`Tdemux {2'b0,d,5'b0};
			4'b110 : q <= #`Tdemux {1'b0,d,6'b0};
			4'b111 : q <= #`Tdemux {d,7'b0};
		endcase
	
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