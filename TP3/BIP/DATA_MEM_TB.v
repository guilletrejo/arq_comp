`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:51:16 10/12/2018
// Design Name:   DATA_MEM
// Module Name:   /home/nestormann/Documents/arq_comp/TP3/BIP/DATA_MEM_TB.v
// Project Name:  BIP
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DATA_MEM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DATA_MEM_TB;

	// Inputs
	reg clk;
	reg Rd;
	reg Wr;
	reg [10:0] Addr;
	reg [15:0] In_Data;

	// Outputs
	wire [15:0] Out_Data;

	// Instantiate the Unit Under Test (UUT)
	DATA_MEM uut (
		.clk(clk), 
		.Rd(Rd), 
		.Wr(Wr), 
		.Addr(Addr), 
		.In_Data(In_Data), 
		.Out_Data(Out_Data)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk);
		clk = 0;
		Rd = 0;
		Wr = 0;
		Addr = 0;
		In_Data = 0;

		// Wait 100 ns for global reset to finish
		#10 	In_Data = 32;
		#10	Wr=1;
		#50 	clk=1;
		#10	Wr=0;
		#50 	clk=0;
				Addr=1;
		#50 	clk=1;
		// Add stimulus here

	end
      
endmodule

