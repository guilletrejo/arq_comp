`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:42:34 02/18/2019
// Design Name:   INSTRUCTION_MEM
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPS/INSTRUCTION_MEM_TEST.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: INSTRUCTION_MEM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module INSTRUCTION_MEM_TEST;

	// Inputs
	reg clk;
	reg Wr;
	reg [31:0] Addr;
	reg [31:0] In_Data;

	// Outputs
	wire [31:0] Data;
	wire wire_douta;

	// Instantiate the Unit Under Test (UUT)
	INSTRUCTION_MEM uut (
		.clk(clk), 
		.Wr(Wr), 
		.Addr(Addr), 
		.In_Data(In_Data), 
		.Data(Data), 
		.wire_douta(wire_douta)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		Addr = 0;
		Wr = 1;
		In_Data = 'hac030000;
		#100 clk = ~clk;
		#100 clk = ~clk;
		In_Data = 'h00423821;
		Addr = 1;
		#100 clk = ~clk;
		#100 clk = ~clk;
		In_Data = 'h00231023;
		Addr = 2;
		#100 clk = ~clk;
		#100 clk = ~clk;
		Wr = 0;
		Addr = 0;
		#100 clk = ~clk;
		#100 clk = ~clk;
		Addr = 1;
		#100 clk = ~clk;
		#100 clk = ~clk;
		Addr = 2;
	end
	
endmodule

