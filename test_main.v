`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:05:43 08/16/2018
// Design Name:   main
// Module Name:   C:/Users/Guille/ARQ_TP1_ALU/test_main.v
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

module test_main;

	// Inputs
	reg [3:0] Op;
	

	// Outputs
	wire [3:0] out;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.Op(Op), 
		.out(out)
	);

	initial begin
		$monitor($time, Op,out);
		// Initialize Inputs
		Op = 0;
	

		// Wait 100 ns for global reset to finish
		#10 Op=4'b1000;
      #10 Op=4'b1001;
		// Add stimulus here
		
	end
      
endmodule

