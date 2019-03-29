`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:12:39 03/12/2019
// Design Name:   DATA_MEM
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPSNexys3/DATA_MEM_TEST.v
// Project Name:  MIPS
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

module DATA_MEM_TEST;

	// Inputs
	reg [7:0] Addr;
	reg [31:0] In_Data;
	reg clk;
	reg Wr;
	reg Rd;

	// Outputs
	wire [31:0] Out_Data;
	wire [31:0] douta_wire;

	// Instantiate the Unit Under Test (UUT)
	DATA_MEM uut (
		.Addr(Addr), 
		.In_Data(In_Data), 
		.clk(clk), 
		.Wr(Wr), 
		.Rd(Rd), 
		.Out_Data(Out_Data), 
		.douta_wire(douta_wire)
	);

	initial begin
		// Initialize Inputs
		Addr = 0;
		In_Data = 0;
		clk = 0;
		Wr = 0;
		Rd = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		clk = ~clk; //pos
		#10 In_Data = 3;
		#10 clk = ~clk; //neg
		// Add stimulus here
		Wr = 1;
		#10 clk = ~clk; //pos
		#10 clk = ~clk;//neg
		#10 Wr = 0;
		#10 Rd = 1;
		clk = ~clk;//pos
		#10 clk = ~clk;
		#10 clk = ~clk;
		#10 Rd = 0;
		#10 clk = ~clk;
		#10 clk = ~clk;

	end
      
endmodule

