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
	 
	 input signed [7:0] in;
	 input [7:0] inB;
	 input [5:0] inOp;
	 
	 output reg [7:0] tout;
	 
	 always @*
	 begin
		case(inOp)
			6'b100000:
			begin
				tout = in + inB;
			end
			6'b100010:
			begin
				tout = in - inB;
			end
			6'b100100:
			begin
				tout = in & inB;
			end
			6'b100101:
			begin
				tout = in | inB;
			end
			6'b100110:
			begin
				tout = in ^ inB;
			end
			6'b000011:
			begin
				tout = in >>> inB;
			end
			6'b000010:
			begin
				tout = in >> inB;
			end
			6'b100111:
			begin
				tout = ~(in | inB);
			end
			default:
			begin
				tout = 0;
			end
		endcase
	 end


endmodule
