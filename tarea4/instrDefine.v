// Archivo para definir el código de las instrucciones del CPU

// Código de las instrucciones del CPU.
`define NOP		6'h00
`define LDA		6'h01
`define LDB 	6'h02
`define LDCA 	6'h03
`define LDCB 	6'h04
`define STA  	6'h05
`define STB  	6'h06
`define ADDA 	6'h07
`define ADDB 	6'h08
`define ADDCA	6'h09
`define ADDCB	6'h0A
`define SUBA  	6'h0B
`define SUBB  	6'h0C
`define SUBCA 	6'h0D
`define SUBCB 	6'h0E
`define ANDA	6'h0F
`define ANDB 	6'h10
`define ANDCA 	6'h11
`define ANDCB	6'h12
`define ORA		6'h13
`define ORB		6'h14
`define ORCA	6'h15
`define ORCB	6'h16
`define ASLA	6'h17
`define ASRA	6'h18
`define JMP		6'h19
`define BAEQ	6'h1A
`define BANE	6'h1B
`define BACS	6'h1C
`define BACC	6'h1D
`define BAMI	6'h1E
`define BAPL	6'h1F
`define BBEQ	6'h20
`define BBNE	6'h21
`define BBCS	6'h22
`define BBCC	6'h23
`define BBMI	6'h24
`define BBPL	6'h25


// Tamaños para el ROM.
`define WIDTH_INSTR_MEM 16
`define LENGTH_INSTR_MEM 10

// Tamaños para el RAM.
`define WIDTH_DATA_MEM 8
`define LENGTH_DATA_MEM 10


// Cantidad de bits de la operacion
`define OPERATION_SIZE 6