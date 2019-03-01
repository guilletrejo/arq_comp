`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:52:42 02/18/2019
// Design Name:   IF_ID
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPS/IF_ID_TEST2.v
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

module IF_ID_TEST2;

	// Inputs
	reg clk;
	reg reset;
	reg [2:0] in_pc_src;
	reg [31:0] in_pc_jump;
	reg [31:0] in_pc_register;
	reg [31:0] in_branch_address;
	reg stall_flag;
	reg [31:0] in_addr_debug;
	reg debug_flag;
	reg [31:0] in_ins_to_mem;
	reg wea_ram_inst;

	// Outputs
	wire [31:0] out_pc_branch;
	wire [31:0] out_instruction;
	wire [31:0] out_pc;
	wire out_halt_flag_if;

	// Instantiate the Unit Under Test (UUT)
	IF_ID uut (
		.clk(clk), 
		.reset(reset), 
		.in_pc_src(in_pc_src), 
		.in_pc_jump(in_pc_jump), 
		.in_pc_register(in_pc_register), 
		.in_branch_address(in_branch_address), 
		.stall_flag(stall_flag), 
		.in_addr_debug(in_addr_debug), 
		.debug_flag(debug_flag), 
		.in_ins_to_mem(in_ins_to_mem), 
		.out_pc_branch(out_pc_branch), 
		.out_instruction(out_instruction), 
		.out_pc(out_pc), 
		.out_halt_flag_if(out_halt_flag_if),
		.wea_ram_inst(wea_ram_inst)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk,out_pc,out_instruction);
		clk = 1;
		reset = 0;
		in_pc_src = 0;
		in_pc_jump = 0;
		in_pc_register = 0;
		in_branch_address = 0;
		stall_flag = 0;
		in_addr_debug = 0;
		debug_flag = 0;
		in_ins_to_mem = 0;
		wea_ram_inst=0;

		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;
		wea_ram_inst=1;
		in_ins_to_mem = 'hac030000;
		#200 clk=1;
		#200 clk=0;
		wea_ram_inst=0;
		#200 clk=1;
		#200 clk=0;		
		wea_ram_inst=1;
		in_ins_to_mem = 'hac033333;
		#200 clk=1;
		#200 clk=0;	
		
		#200 clk=1;
		#200 clk=0;

	end
      
endmodule

