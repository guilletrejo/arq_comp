`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  ALU
//////////////////////////////////////////////////////////////////////////////////

module ALU #(
	parameter len_data = 32,
	parameter len_op = 4
	)(
	//Inputs
	inA,
	inB,
	inOp,

	//Output
	RESULT_OUT,
	zero_flag
    );

	input signed [len_data-1 : 0] inA;
	input signed [len_data-1 : 0] inB;
	input signed [len_op-1 : 0] inOp;

	output reg [len_data - 1 : 0] RESULT_OUT;
	output reg zero_flag;

	always @(*)
	begin
		zero_flag = 0;

		case (inOp)
			4'b 0000: RESULT_OUT = inB << inA; //shift left logico
			4'b 0001: RESULT_OUT = inB >> inA; //shift right logico
			4'b 0010: RESULT_OUT = inB >>> inA; //shift right aritmetico
			4'b 0011: RESULT_OUT = inA + inB; //add
			
			4'b 0100: 
			begin
				RESULT_OUT = inA < inB; //  (inA < inB = 1 o 0 a OUT)
				zero_flag = inA == inB ? 1 : 0; //BRANCH
			end

			4'b 0101: RESULT_OUT = inA & inB; //and
			4'b 0110: RESULT_OUT = inA | inB; //or
			4'b 0111: RESULT_OUT = inA ^ inB; //xor
			4'b 1000: RESULT_OUT = ~(inA | inB); //nor
			4'b 1001: RESULT_OUT = inB << 16; //LUI
			4'b 1010: RESULT_OUT = inA - inB; //restar
			default: RESULT_OUT = 0;
		endcase	
	end

	endmodule