`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:03:13 10/11/2018
// Design Name:   TOP
// Module Name:   /home/nestormann/Documents/arq_comp/TP3/BIP/control_program_mem_tb.v
// Project Name:  BIP
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_program_mem_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [1:0] SelA;
	wire SelB;
	wire WrAcc;
	wire Op;
	wire WrRam;
	wire RdRam;
	wire [10:0] Operand;

	// Instantiate the Unit Under Test (UUT)
	TOP uut (
		.clk(clk), 
		.reset(reset), 
		.SelA(SelA), 
		.SelB(SelB), 
		.WrAcc(WrAcc), 
		.Op(Op), 
		.WrRam(WrRam), 
		.RdRam(RdRam), 
		.Operand(Operand)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk);
		clk = 1;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#10 reset=1;
		#10 reset=0;
		//#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#10 reset=1;
		#50 clk=0;
		#10 reset=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		#50 clk=0;
		// Add stimulus here

	end
      
endmodule

