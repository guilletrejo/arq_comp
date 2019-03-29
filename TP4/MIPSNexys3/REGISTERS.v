`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  REGISTROS
//////////////////////////////////////////////////////////////////////////////////

module REGISTERS#(
	parameter len_data = 32,
	parameter depth = 32,
	parameter num_bits = 5 //$clog2(depth)
	)
    (
	input clk,
	input ctrl_clk_mips,
	input reset,
	input RegWrite,
	input [num_bits-1:0] read_register_1,
	input [num_bits-1:0] read_register_2,
	input [num_bits-1:0] write_register,
	input [len_data-1:0] write_data,


	//SALIDAS PARA MANDAR A DEBUG.U
	output [len_data-1:0] wire_read_data_0, 
	output [len_data-1:0] wire_read_data_1,
	output [len_data-1:0] wire_read_data_2, 
	output [len_data-1:0] wire_read_data_3,
	output [len_data-1:0] wire_read_data_4, 
	output [len_data-1:0] wire_read_data_5,
	output [len_data-1:0] wire_read_data_6,
	output [len_data-1:0] wire_read_data_7,
    //-------------------------------------

	output [len_data-1:0] reg_jump_register,
	output reg [len_data-1:0] read_data_1,
	output reg [len_data-1:0] read_data_2
    );

	reg [len_data-1:0] registers_mips [depth-1:0]; // Banco de registros (tam. es len_data y cantidad es depth) 

	assign wire_read_data_0 = registers_mips[0]; 
	assign wire_read_data_1 = registers_mips[1]; 
	assign wire_read_data_2 = registers_mips[2]; 
	assign wire_read_data_3 = registers_mips[3]; 
	assign wire_read_data_4 = registers_mips[4]; 
	assign wire_read_data_5 = registers_mips[5]; 
	assign wire_read_data_6 = registers_mips[6]; 
	assign wire_read_data_7 = registers_mips[7]; 
	
	assign reg_jump_register = registers_mips[read_register_1];

	generate
		integer i;		
		initial
		begin
			for (i = 0; i < depth; i = i + 1)
			begin
				registers_mips[i] = i; // reg0 = 0. reg1 = 1. reg2 = 2... etc.
			end
			read_data_1 <= 0;
			read_data_2 <= 0;
		end
	endgenerate

	always @(negedge clk)
	begin
		if (reset)
		begin
			read_data_1 <= 0;
			read_data_2 <= 0;
		end

		else if(ctrl_clk_mips) begin
			read_data_1 <= registers_mips[read_register_1];
			read_data_2 <= registers_mips[read_register_2];
		end
	end

	always @(posedge clk)
	begin
		if(ctrl_clk_mips)
		begin
			if (RegWrite) 
			begin
				registers_mips[write_register] <= write_data;				
			end
		end
	end

endmodule
