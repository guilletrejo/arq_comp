`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:09 09/27/2018 
// Design Name: 
// Module Name:    t 
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
module t(
		in,
		inB,
		inOp,
		
		tout
    );
	 
	 input [7:0] in;
	 input [7:0] inB;
	 input [1:0] inOp;
	 
	 output reg [7:0] tout;
	 
	 always @*
	 begin
		case(inOp)
			2'b00:
			begin
				tout = in + inB;
			end
			2'b01:
			begin
				tout = in - inB;
			end
			2'b10:
			begin
				tout = in & inB;
			end
			2'b11:
			begin
				tout = in | inB;
			end
		endcase
	 end


endmodule
