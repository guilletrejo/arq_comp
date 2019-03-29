`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: TOP DI TUTTI TOP
//////////////////////////////////////////////////////////////////////////////////
module CLK_COUNTER
	 #(
        parameter len_counter = 8
    )
	 (
			input done,
			input start,
			input clk,
			input reset,
			
			output reg [len_counter-1:0]count=0 	//contador de clk
    );
	 
	 always @(negedge clk)
    begin
        if(reset)
        begin
          count = 0;
        end
        else if(start && ~done)
        begin
          count = count + 1;
        end
    end


endmodule
