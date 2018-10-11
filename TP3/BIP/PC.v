`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: PC
//////////////////////////////////////////////////////////////////////////////////
module PC
    #(
        parameter len_addr = 11  
    )
    (
        input clk,
        input ena,              // Enable para copiar valor de la entrada del PC a la salida
        input [len_addr-1:0]adder_input,      // Aumenta el valor del PC.
        input reset,            // Reinicia el PC a cero.

        output reg [len_addr-1 : 0] pc_out = 0 // Direccion que se leera de PROGRAM_MEM
    );

    always @(negedge clk) // Podria hacer posedge aca?
    begin
      if(reset)
      begin
        pc_out = 0;
      end
      else if(ena)
      begin
        pc_out = adder_input;
      end
    end    

endmodule
