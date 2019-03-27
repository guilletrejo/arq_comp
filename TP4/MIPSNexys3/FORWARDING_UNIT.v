`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  UNIDAD DE CORTOCIRCUITO
//////////////////////////////////////////////////////////////////////////////////

module FORWARDING_UNIT #(
	parameter num_bits = 5
	)(
	/* ...reg_write --> Si esta en 1, es que se va a escribir un registro. */
	input ex_mem_reg_write,	// Instruccion que ya se ejecuto y esta por escribir en memoria (sw) o por pasar a MEM_WB si no es un store
	input mem_wb_reg_write,	// Instruccion que ya paso la etapa MEM y esta por escribir los registros
	input [num_bits-1:0] ex_mem_rd,		// registro de destino despues de etapa EX, RT o RD (donde voy a guardar el resultado de la ALU)
	input [num_bits-1:0] mem_wb_rd,		// registro de destino despues de etapa MEM
	input [num_bits-1:0] id_ex_rs,		// registro de instr siguiente que puede necesitar forwarding
	input [num_bits-1:0] id_ex_rt,		// registro de instr siguiente que puede necesitar forwarding
    
	output reg [1:0] forwarding_muxA,	// control mux entrada A de la ALU BITS DE SELECCION DE LOS MUXES
	output reg [1:0] forwarding_muxB 	// control mux entrada B de la ALU
    );

    /*
        La explicacion de los if esta en la quinta edicion del libro pag308
    */
	always @(*) begin 

		/* Lo mismo pero para RS */

		if (ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd == id_ex_rs))
			forwarding_muxA = 2'b10;
		else
			forwarding_muxA = 2'b00;
		
		if (ex_mem_reg_write && (ex_mem_rd !=0) && (ex_mem_rd == id_ex_rt))
			forwarding_muxB = 2'b10;
		else
			forwarding_muxB = 2'b00;

		if (mem_wb_reg_write && (mem_wb_rd != 0) && !(ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd != id_ex_rs)) 
			&& (mem_wb_rd == id_ex_rs))
			forwarding_muxA = 2'b01;
		else
			forwarding_muxA = 2'b00;
		
		if (mem_wb_reg_write && (mem_wb_rd != 0) && !(ex_mem_reg_write && (ex_mem_rd != 0) && (ex_mem_rd != id_ex_rt))
			&& (mem_wb_rd == id_ex_rt))
			forwarding_muxB = 2'b01; 
		else
			forwarding_muxA = 2'b00;

		/*if(mem_wb_reg_write == 1 & mem_wb_rd == id_ex_rs & (ex_mem_reg_write == 0 | ex_mem_rd != id_ex_rs))
			forwarding_muxA <= 2'b10;
		else if (ex_mem_reg_write == 1 & ex_mem_rd == id_ex_rs)
			forwarding_muxA <= 2'b01;
		else
			forwarding_muxA <= 2'b00;*/

		/* Lo mismo pero para RT... ACA TENDRIA QUE ENTRAR en el caso add 5, 9, 0 ... sw 5, 0(1) , pq el 5 en el sw es RT */

		/*if(mem_wb_reg_write == 1 & mem_wb_rd == id_ex_rt & (ex_mem_reg_write == 0 | ex_mem_rd != id_ex_rt))
			forwarding_muxB <= 2'b10;
		else if (ex_mem_reg_write == 1 & ex_mem_rd == id_ex_rt)
			forwarding_muxB <= 2'b01;
		else
			forwarding_muxB <= 2'b00;*/
	end

endmodule
