`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:01:29 02/08/2019 
// Design Name: 
// Module Name:    z 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module z(
		input [1:0] a,
		input [1:0]b,
		input [1:0]bb,
		output [1:0] c
    );
	 

	assign c = a < b;


endmodule
