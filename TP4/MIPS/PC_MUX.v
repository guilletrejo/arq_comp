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
        input PCSrc,                            // viene de la Unidad de Control (se hace branch o se suma 4 noma al PC)
        input [len_data-1 : 0] adder_out,       // viene del PC_ADDER
        input [len_data-1 : 0] branch_address,  // viene de EX_MEM

        output reg [len_data - 1 : 0] pc_out    // salida para PC
    );

    always @(*)
    begin
        case (PCSrc)
          0:
            begin
                pc_out <= adder_out;    
            end
          1:
            begin
                pc_out <= branch_address;    
            end
        endcase
    end
endmodule
