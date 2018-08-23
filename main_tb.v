`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:59:23 08/16/2018
// Design Name:   main
// Module Name:   C:/Users/Guille/ARQ_TP1_ALU/main_tb.v
// Project Name:  ARQ_TP1_ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module main_tb
#(parameter bits = 8);
	// Inputs
	reg [5:0] Op;
	reg [bits-1:0] A;
	reg [bits-1:0] B;

	// Outputs
	wire [bits-1:0] out;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.Op(Op), 
		.A(A), 
		.B(B), 
		.out(out)
	);

	initial begin
		$monitor($time, Op,out);
		// Initialize Inputs
		Op = 6'b100000;
		A=8'b10010000;
		B=8'b00000001;

		// Wait 100 ns for global reset to finish
		#100 Op=6'b100111;
		#100 Op=6'b100010;
		#100 Op=6'b100100;
		#100 Op=6'b100101;
		#100 Op=6'b100110;
		#100 Op=6'b000010;
		#100 Op=6'b000011;
		// Add stimulus here
		
	end
      
endmodule

