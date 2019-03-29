`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:04:05 10/11/2018
// Design Name:   PROGRAM_MEM
// Module Name:   /home/nestormann/Documents/arq_comp/TP3/BIP/PROGRAM_MEM_TB.v
// Project Name:  BIP
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PROGRAM_MEM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PROGRAM_MEM_TB;

	// Inputs
	reg clk;
	reg [10:0]Addr;

	// Outputs
	wire [15:0]Data;

	// Instantiate the Unit Under Test (UUT)
	PROGRAM_MEM 
	#(
		.len_addr(11),
		.len_data(16),
		.ram_depth(2048),
		.init_file("program.hex")
	)
	uut (
		.clk(clk), 
		.Addr(Addr), 
		.Data(Data)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk,Data);
		clk = 0;
		Addr = 0;

		// Wait 100 ns for global reset to finish
		#200 clk=1;
		#200 clk=0;
      Addr=1;
		#200 clk=1;
		// Add stimulus here

	end
      
endmodule

