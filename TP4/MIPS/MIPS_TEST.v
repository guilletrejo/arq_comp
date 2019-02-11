`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:25:04 02/08/2019
// Design Name:   TOP_MIPS
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPS/MIPS_TEST.v
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

module MIPS_TEST;

	// Inputs
	reg clk;
	reg reset;
	reg debug_flag;
	reg [31:0] in_addr_debug;
	reg [31:0] in_addr_mem_inst;
	reg [31:0] in_ins_to_mem;
	reg wea_ram_inst;

	// Outputs
	wire [31:0] out_reg0_recolector;
	wire [31:0] out_reg1_recolector;
	wire [31:0] out_reg2_recolector;
	wire [31:0] out_reg3_recolector;
	wire [31:0] out_reg4_recolector;
	wire [31:0] out_reg5_recolector;
	wire [31:0] out_reg6_recolector;
	wire [31:0] out_reg7_recolector;
	
	wire [31:0] out_mem_wire;
	wire [31:0] out_pc;
	wire halt_flag;
	wire [31:0] Latches_1_2;
	wire [31:0] Latches_2_3;
	wire [31:0] Latches_3_4;
	wire [31:0] Latches_4_5;

	// Instantiate the Unit Under Test (UUT)
	TOP_MIPS uut (
		.clk(clk), 
		.reset(reset), 
		.debug_flag(debug_flag), 
		.in_addr_debug(in_addr_debug), 
		.in_addr_mem_inst(in_addr_mem_inst), 
		.in_ins_to_mem(in_ins_to_mem), 
		.wea_ram_inst(wea_ram_inst), 
		.out_reg0_recolector(out_reg0_recolector), 
		.out_reg1_recolector(out_reg1_recolector), 
		.out_reg2_recolector(out_reg2_recolector), 
		.out_reg3_recolector(out_reg3_recolector), 
		.out_reg4_recolector(out_reg4_recolector), 
		.out_reg5_recolector(out_reg5_recolector), 
		.out_reg6_recolector(out_reg6_recolector), 
		.out_reg7_recolector(out_reg7_recolector), 
		.out_mem_wire(out_mem_wire), 
		.out_pc(out_pc), 
		.halt_flag(halt_flag), 
		.Latches_1_2(Latches_1_2), 
		.Latches_2_3(Latches_2_3), 
		.Latches_3_4(Latches_3_4), 
		.Latches_4_5(Latches_4_5)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,out_mem_wire);
		clk = 1;
		reset = 1;
		debug_flag = 0;
		in_addr_debug = 0;
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

