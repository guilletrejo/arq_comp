`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:07:33 03/11/2019
// Design Name:   TOP_MIPS
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPSNexys3/TOP_MIPS3_TEST.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TOP_MIPS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TOP_MIPS3_TEST;

	// Inputs
	reg clk;
	reg reset;
	reg debug_flag;
	reg [7:0] in_addr_mem_inst;
	reg [31:0] in_ins_to_mem;
	reg wea_ram_inst;

	// Outputs
	wire [7:0] led_fpga;
	wire [7:0] out_pc;
	wire halt_flag;

	// Instantiate the Unit Under Test (UUT)
	TOP_MIPS uut (
		.clk(clk), 
		.reset(reset), 
		.debug_flag(debug_flag), 
		.in_addr_mem_inst(in_addr_mem_inst), 
		.in_ins_to_mem(in_ins_to_mem), 
		.wea_ram_inst(wea_ram_inst), 
		.led_fpga(led_fpga), 
		.out_pc(out_pc), 
		.halt_flag(halt_flag)
	);

	initial begin
		// Initialize Inputs
		//$monitor($time,out_mem_wire, out_pc);
		clk = 1;
		reset = 1;
		debug_flag = 0;
		in_addr_mem_inst = 0;
		in_ins_to_mem = 0;
		wea_ram_inst = 0;
		#10 reset = 0;
		#200
		clk = 0;
	end

	always 
	begin
		#200 clk = ~clk;
	end

      
endmodule

