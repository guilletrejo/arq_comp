`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: SIGNAL EXTENSION
//////////////////////////////////////////////////////////////////////////////////
module SIGNAL_EXTENSION
    #(
        parameter len_data = 16,
        parameter len_addr = 11
    )
    (
        input signed [len_addr - 1 : 0] inst_operand, // Operando tomado de la instruccion (tiene 11 bits)

        output reg [len_data - 1 : 0] out_operand     // Operando tomado de la instruccion ya extendido a 16
    );

    wire signed [len_data - 1 : 0] signed_operand;
    assign signed_operand = inst_operand;             // Convierte al operando en signed  

    always @(*)
    begin
        out_operand <= signed_operand;
    end


endmodule
