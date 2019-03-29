`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:10:53 02/08/2019
// Design Name:   z
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPS/zt.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: z
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module zt;

	// Inputs
	reg [1:0] a;
	reg [1:0] b;
	reg [1:0] bb;

	// Outputs
	wire [1:0] c;

	// Instantiate the Unit Under Test (UUT)
	z uut (
		.a(a), 
		.b(b), 
		.bb(bb), 
		.c(c)
	);

	initial begin
		$monitor($time,a,b,c);
		a = 1;
		b = 2;
		bb = 3;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

