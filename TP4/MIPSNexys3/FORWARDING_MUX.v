`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  MUX PARA LAS ENTRADAS DE LA ALU
//////////////////////////////////////////////////////////////////////////////////

module FORWARDING_MUX #(
	parameter len_data = 32
	) (
	input [len_data-1:0] in_reg,		//entrada desde registros
	input [len_data-1:0] in_mem_forw,	//salida de alu de clock anterior
	input [len_data-1:0] in_wb_forw,	//salida del mux final de writeback
	input [1:0] select,
	output [len_data-1:0] out_mux
    );

    assign out_mux 	= (select == 2'b00) ? in_reg
    				: (select == 2'b01) ? in_mem_forw // ex/mem
    									: in_wb_forw; // mem/wb
endmodule
