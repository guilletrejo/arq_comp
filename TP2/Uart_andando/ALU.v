`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2017 07:21:59 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define lenghtIN 8
`define lenghtOP 6

module ALU(
	//inputs
	A,
	B,
	OPCODE,

	//output
	RESULT_OUT  
    );

	parameter lenghtIN = `lenghtIN; 	
	parameter lenghtOP = `lenghtOP;

	input signed [lenghtIN-1 : 0] A;
	input signed [lenghtIN-1 : 0] B;
	input signed [1 : 0] OPCODE;

	output reg [lenghtIN - 1 : 0] RESULT_OUT; 

	always @(*)
	begin
		RESULT_OUT = A + B;
		/*case (OPCODE)
			2'b00: 
				begin
					RESULT_OUT = A + B;
				end
			2'b01: 
				begin
					RESULT_OUT = A - B;
				end
			2'b10: 
				begin
					RESULT_OUT = A & B;
				end
			2'b11: 
				begin
					RESULT_OUT = A | B;
				end*/
			/*6'b 100110: 
				begin
					RESULT_OUT = A ^ B;
				end
			6'b 000011: 
				begin
					RESULT_OUT = A >>> B;
				end
			6'b 000010: 
				begin
					RESULT_OUT = A >> B;
				end
			6'b 100111: 
				begin 	
					RESULT_OUT = ~(A | B);
				end
			default: RESULT_OUT = 0;*/
		//endcase	
	end

	endmodule
