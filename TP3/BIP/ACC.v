`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: ACC
//////////////////////////////////////////////////////////////////////////////////
module ACC
    #(
        parameter len_data = 16
    )
    (
        input clk,
        input reset,      
        input [len_data - 1 : 0] in,   // salida del MUX A
        input ena,                     // WrAcc que viene de control (instruction decoder)

        output reg [len_data - 1 : 0] out = 0 // salida ACC
    );

    always @(posedge clk)
    begin
      if(reset)
        begin
          out = 0;  
        end
      else if(ena)
        begin
          out = in;
        end
    end

endmodule
