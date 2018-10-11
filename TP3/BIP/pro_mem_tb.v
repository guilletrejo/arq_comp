`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:27:55 10/11/2018
// Design Name:   PROGRAM_MEM
// Module Name:   /home/nestormann/Documents/arq_comp/TP3/BIP/pro_mem_tb.v
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

module pro_mem_tb;

	// Inputs
	reg clk;
	reg [10:0] Addr;

	// Outputs
	wire [15:0] Data;

	// Instantiate the Unit Under Test (UUT)
	PROGRAM_MEM uut (
		.clk(clk), 
		.Addr(Addr), 
		.Data(Data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		Addr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

