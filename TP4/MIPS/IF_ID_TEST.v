`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:03:52 02/06/2019
// Design Name:   IF_ID
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPS/IF_ID_TEST.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IF_ID
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module IF_ID_TEST;

	// Inputs
	reg clk;
	reg reset;
	reg in_pc_src;
	reg [31:0] in_branch_address;
	reg stall_flag;

	// Outputs
	wire [31:0] out_pc_branch;
	wire [31:0] out_instruction;
	wire [31:0] out_pc;
	wire [31:0] out_adder;

	// Instantiate the Unit Under Test (UUT)
	IF_ID uut (
		.clk(clk), 
		.reset(reset), 
		.in_pc_src(in_pc_src), 
		.in_branch_address(in_branch_address), 
		.stall_flag(stall_flag), 
		.out_pc_branch(out_pc_branch), 
		.out_instruction(out_instruction), 
		.out_pc(out_pc),
		.out_adder(out_adder)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk,out_adder,out_pc,out_instruction);
		clk = 0;
		reset = 0;
		in_pc_src = 0; //selecciona salida adder
		in_branch_address = 1; // no usamo
		stall_flag = 0; // inicia deshabilitado

		#200 clk=1;
		#200 clk=0;
		
		stall_flag = 1;
		
		#200 clk=1;
		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;		
		
		#200 clk=1;
		#200 clk=0;	
		
		#200 clk=1;
		#200 clk=0;
		
		in_pc_src = 1;
		
		#200 clk=1;
		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;
		
	end
      
endmodule

