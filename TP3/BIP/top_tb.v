`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:07:39 10/12/2018
// Design Name:   TOP
// Module Name:   /home/nestormann/Documents/arq_comp/TP3/BIP/top_tb.v
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

module top_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	/*wire [15:0] acumulador;
	wire [10:0] pc;*/
	wire [7:0] led_acc;

	// Instantiate the Unit Under Test (UUT)
	TOP uut (
		.clk(clk), 
		.reset(reset), 
		.led_acc(led_acc)
		//.acumulador(acumulador), 
		//.pc(pc)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk);
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		//#10 reset=1;
		//#10 reset=0;
		#50 clk=1;
		#50 clk=0;
		#50 clk=1;
		//#10 reset=1;
		#50 clk=0;
		//#10 reset=0;
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

