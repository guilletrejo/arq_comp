`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  UNIDAD DE DETECCION DE RIESGOS PARA LOAD
//////////////////////////////////////////////////////////////////////////////////

module HAZARD_DU #(
	parameter num_bits = 5
	)(
	input id_ex_mem_read, /* Solo es 1 en los LOAD */

	/* rd, rs, RT (RS primer operando, RT segundo operando)... pero en inmediatos, es: RT, rs, ctte. (RS es el 1er operando y RT es el de destino) 
	
	PERO EN LOADS ES: rt, offset(base) --> RT es el de destino!!!!
	
	*/
	
	/* operando decodificado de la instruccion que se esta por ejecutar. */  
	input [num_bits-1:0] id_ex_rt, 

	/* en el latch IF_ID, ya se saco de la instruccion[26:21], por lo tanto ya se sabe cual sera, YA SE DECODIFICO */
	input [num_bits-1:0] if_id_rs, 

	/* Idem que RS. Entonces, ya se saben los 2 operandos de la instruccion que viene, o en el caso de un inmediato, se sabe el destino y el registro operando*/
	input [num_bits-1:0] if_id_rt,

	/* Si hay un riesgo, este bit se pone en 1. */
	output stall_flag
    );

	/* Es un load? y (Reg. de destino del load que se va a ejecutar es igual a RS (1er operando) O al RT (2do operando) de la instruccion que sigue  */
	assign stall_flag = ( id_ex_mem_read == 1 & ( (id_ex_rt == if_id_rs) | (id_ex_rt == if_id_rt) ) ) ?
								1'b1 : 1'b0;
endmodule