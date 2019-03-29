`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: ALU
//////////////////////////////////////////////////////////////////////////////////

`define lenghtIN 8
`define lenghtOP 6

module ALU(
		inA,
		inB,
		inOp,
		
		RESULT_OUT
    );
	 
	 parameter lenghtIN = `lenghtIN; 	
	 parameter lenghtOP = `lenghtOP;
	 
	 input signed [lenghtIN - 1 : 0] inA;
	 input [lenghtIN - 1 : 0] inB;
	 input [lenghtOP - 1 : 0] inOp;
	 
	 output reg [7:0] RESULT_OUT;
	 
	 always @*
	 begin
		case(inOp)
			6'b100000:
			begin
				RESULT_OUT = inA + inB;
			end
			6'b100010:
			begin
				RESULT_OUT = inA - inB;
			end
			6'b100100:
			begin
				RESULT_OUT = inA & inB;
			end
			6'b100101:
			begin
				RESULT_OUT = inA | inB;
			end
			6'b100110:
			begin
				RESULT_OUT = inA ^ inB;
			end
			6'b000011:
			begin
				RESULT_OUT = inA >>> inB;
			end
			6'b000010:
			begin
				RESULT_OUT = inA >> inB;
			end
			6'b100111:
			begin
				RESULT_OUT = ~(inA | inB);
			end
			default:
			begin
				RESULT_OUT = 0;
			end
		endcase
	 end


endmodule
