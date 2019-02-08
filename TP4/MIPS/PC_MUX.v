`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  MULTIPLEXOR DEL PC
//////////////////////////////////////////////////////////////////////////////////
module PC_MUX #(
        parameter len_data = 32
    )
    (
        input [2:0] PCSrc,                      // viene de la Unidad de Control (se hace branch o se suma 4 noma al PC)
        input [len_data-1 : 0] adder_out,       // viene del PC_ADDER
        input [len_data-1 : 0] branch_address,  // viene de EX_MEM
        input [len_data-1 : 0] jump_address,    // viene de ID_EX?? o EX_MEM? 

        output reg [len_data - 1 : 0] pc_out    // salida para PC
    );

    always @(*)
    begin
        case (PCSrc)
    		3'b 100: pc_out <= jump_address;
    		//3'b 010: pc_out <= register;
    		3'b 001: pc_out <= branch_address;
    		default: pc_out <= adder_out; 
        endcase
    end
endmodule