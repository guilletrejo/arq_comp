`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  UNIDAD DE DETECCION DE RIESGOS
//////////////////////////////////////////////////////////////////////////////////

module HAZARD_DU #(
	parameter num_bits = 5
	)(
	input id_ex_mem_read,
	input [num_bits-1:0] id_ex_rt,
	input [num_bits-1:0] if_id_rs,
	input [num_bits-1:0] if_id_rt,

	output stall_flag
    );


	assign stall_flag = ( id_ex_mem_read == 1 & ( (id_ex_rt == if_id_rs) | (id_ex_rt == if_id_rt) ) ) ?
								1'b1 : 1'b0;
endmodule