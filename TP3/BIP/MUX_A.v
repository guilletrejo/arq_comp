`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: MULTIPLEXOR DEL ACC
//////////////////////////////////////////////////////////////////////////////////
`define len_mux_a 2
module MUX_A
    #(
        parameter len_data = 16,
        parameter len_mux_a = `len_mux_a
    )
    (
        input [len_mux_a - 1 : 0] SelA,         // viene de Control (instruction decoder)
        input [len_data - 1 : 0] inst_operand,  // viene de signal extension
        input [len_data - 1 : 0] alu_result,    // salida de la ALU
        input [len_data - 1 : 0] data_mem_out,  // salida de DATA_MEM

        output [len_data - 1 : 0] out           // salida para ACC
    );

    always @(*)
    begin
        case (SelA)
          `len_mux_a'b00:
            begin
                out <= data_mem_out;    
            end
          `len_mux_a'b01:
            begin
                out <= inst_operand;    
            end
          `len_mux_a'b10:
            begin
                out <= alu_result;    
            end
          default:
            begin
              out <= 0;
            end 
        endcase
    end

endmodule
