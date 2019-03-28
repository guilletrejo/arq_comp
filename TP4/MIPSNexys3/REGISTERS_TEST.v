`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:54:12 02/07/2019
// Design Name:   REGISTERS
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPS/REGISTERS_TEST.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: REGISTERS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module REGISTERS_TEST;

	// Inputs
	reg clk;
	reg reset;
	reg RegWrite;
	reg [4:0] read_register_1;
	reg [4:0] read_register_2;
	reg [4:0] write_register;
	reg [31:0] write_data;

	// Outputs
	wire [31:0] wire_read_data_1;
	wire [31:0] read_data_1;
	wire [31:0] read_data_2;

	// Instantiate the Unit Under Test (UUT)
	REGISTERS uut (
		.clk(clk), 
		.reset(reset), 
		.RegWrite(RegWrite), 
		.read_register_1(read_register_1), 
		.read_register_2(read_register_2), 
		.write_register(write_register), 
		.write_data(write_data), 
		.wire_read_data_1(wire_read_data_1), 
		.read_data_1(read_data_1), 
		.read_data_2(read_data_2)
	);

	initial begin
		// Initialize Inputs
		$monitor($time,clk,RegWrite,read_register_1,write_register,write_data,read_data_1);
		clk = 0;
		reset = 0;
		RegWrite = 0;
		read_register_1 = 0;
		read_register_2 = 0;
		write_register = 0;
		write_data = 0;

		#200 clk=1;
		#200 clk=0;
		
		read_register_1 = 1;
		
		#200 clk=1;
		#200 clk=0;
		
		read_register_1 = 2;
		
		#200 clk=1;
		#200 clk=0;
		
		read_register_1 = 3;
		
		#200 clk=1;
		#200 clk=0;
		
		read_register_1 = 31;
		
		#200 clk=1;
		#200 clk=0;
		
		write_register = 2;
		write_data = {32{1'b1}};
		RegWrite = 1;
		
		#200 clk=1;
		#200 clk=0;
		
		read_register_1 = 2;
		
		#200 clk=1;
		#200 clk=0;
	end
      
endmodule

