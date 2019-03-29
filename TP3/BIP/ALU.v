`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: UNIDAD ARITMETICA
//////////////////////////////////////////////////////////////////////////////////
module ALU
    #(
        parameter len_data = 16
    )
    (
        input [len_data - 1 : 0] in_A,   // primer operando, viene de ACC
        input [len_data - 1 : 0] in_B,   // segundo operando, viene de muxB
        input Op,                        // viene de control (instruction decoder), suma = 0. resta = 1

        output reg [len_data - 1 : 0] result // salida de la ALU
    );

    always@(*)
    begin
      case (Op)
        0:
         begin
           result = in_A + in_B;
         end
        1:
         begin
           result = in_A - in_B;
         end
      endcase
    end
    
endmodule
