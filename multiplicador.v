`timescale 1ns/1ps
`include "datapath.v"
`include "FSM.v"

module multiplicador(prod, a, b, clk);

datapath data(a,b,prod,b_sel,a_sel,prod_sel,b_lsb,add_sel,clk,reset);

FSM control(Clock, Reset, valid_data, ack, b_lsb, a_sel, b_sel, prod_sel, Done_Flag);

endmodule