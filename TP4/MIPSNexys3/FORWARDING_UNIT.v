`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  UNIDAD DE CORTOCIRCUITO
//////////////////////////////////////////////////////////////////////////////////

module FORWARDING_UNIT #(
	parameter num_bits = 5//$clog2(len_data)
	)(
	input ex_mem_reg_write,	// flag
	input mem_wb_reg_write,	// flag
	input [num_bits-1:0] ex_mem_rd,		// registro ya calculado, a forwardear
	input [num_bits-1:0] mem_wb_rd,		// registro ya calculado, a forwardear
	input [num_bits-1:0] id_ex_rs,		// registro de instr siguiente que puede necesitar forwarding
	input [num_bits-1:0] id_ex_rt,		// registro de instr siguiente que puede necesitar forwarding
    
	output reg [1:0] forwarding_muxA,	// control mux entrada A de la ALU BITS DE SELECCION DE LOS MUXES
	output reg [1:0] forwarding_muxB 	// control mux entrada B de la ALU
    );

    /*
        La explicacion de los if esta en la quinta edicion del libro pag308
    */
	always @(*) begin 
		if(mem_wb_reg_write == 1 & mem_wb_rd == id_ex_rs & (ex_mem_reg_write == 0 | ex_mem_rd != id_ex_rs))
			forwarding_muxA <= 2'b10;
		else if (ex_mem_reg_write == 1 & ex_mem_rd == id_ex_rs)
			forwarding_muxA <= 2'b01;
		else
			forwarding_muxA <= 2'b00;


		if(mem_wb_reg_write == 1 & mem_wb_rd == id_ex_rt & (ex_mem_reg_write == 0 | ex_mem_rd != id_ex_rt))
			forwarding_muxB <= 2'b10;
		else if (ex_mem_reg_write == 1 & ex_mem_rd == id_ex_rt)
			forwarding_muxB <= 2'b01;
		else
			forwarding_muxB <= 2'b00;
	end

endmodule
