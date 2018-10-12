`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:16:16 10/12/2018
// Design Name:   SIGNAL_EXTENSION
// Module Name:   /home/nestormann/Documents/arq_comp/TP3/BIP/signal_extension_tb.v
// Project Name:  BIP
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SIGNAL_EXTENSION
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module signal_extension_tb;

	// Inputs
	reg [10:0] inst_operand;

	// Outputs
	wire [15:0] out_operand;

	// Instantiate the Unit Under Test (UUT)
	SIGNAL_EXTENSION uut (
		.inst_operand(inst_operand), 
		.out_operand(out_operand)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,inst_operand);
		inst_operand = 0;

		// Wait 100 ns for global reset to finish
		#100 inst_operand=11'b10110001110;
		#100 inst_operand=11'b00110001110;

        
		// Add stimulus here

	end
      
endmodule

