`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:21:05 03/11/2019
// Design Name:   TOP
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPSNexys3/TOP_TEST.v
// Project Name:  MIPS
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

module TOP_TEST;

	// Inputs
	reg CLK100MHZ;
	reg SWITCH_RESET;
	reg RX_INPUT;

	// Outputs
	wire TX_OUTPUT;
	wire [7:0] led_fpga;

	// Instantiate the Unit Under Test (UUT)
	TOP uut (
		.CLK100MHZ(CLK100MHZ), 
		.SWITCH_RESET(SWITCH_RESET), 
		.RX_INPUT(RX_INPUT), 
		.TX_OUTPUT(TX_OUTPUT), 
		.led_fpga(led_fpga)
	);

	initial begin
		// Initialize Inputs
		CLK100MHZ = 0;
		SWITCH_RESET = 0;
		RX_INPUT = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

