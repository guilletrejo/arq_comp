`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: MULTIPLEXOR B
//////////////////////////////////////////////////////////////////////////////////
module MUX_B #(
        parameter len_data = 16
    )
    (
        input SelB,                             // viene de Control (instruction decoder)
        input [len_data - 1 : 0] inst_operand,  // viene de signal extension
        input [len_data - 1 : 0] data_mem_out,  // salida de DATA_MEM

        output reg [len_data - 1 : 0] out           // salida para ACC
    );

    always @(*)
    begin
        case (SelB)
          0:
            begin
                out <= data_mem_out;    
            end
          1:
            begin
                out <= inst_operand;    
            end
        endcase
    end
endmodule
