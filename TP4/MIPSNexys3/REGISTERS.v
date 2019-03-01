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
	input reset,
	input RegWrite,
	input [num_bits-1:0] read_register_1,
	input [num_bits-1:0] read_register_2,
	input [num_bits-1:0] write_register,
	input [len_data-1:0] write_data,

	/*output [len_data-1:0] wire_read_data_0, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_1, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_2, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_3, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_4, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_5, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_6, // ver despues para que lo usa
	output [len_data-1:0] wire_read_data_7, // ver despues para que lo usa*/


	output [len_data-1:0] reg_jump_register,
	output reg [len_data-1:0] read_data_1,
	output reg [len_data-1:0] read_data_2
    );

	reg [len_data-1:0] registers_mips [depth-1:0]; // Banco de registros (tam. es len_data y cantidad es depth) 

	/*assign wire_read_data_0 = registers_mips[0]; // Algo desconozido aun
	assign wire_read_data_1 = registers_mips[1]; // Algo desconozido aun
	assign wire_read_data_2 = registers_mips[2]; // Algo desconozido aun
	assign wire_read_data_3 = registers_mips[3]; // Algo desconozido aun
	assign wire_read_data_4 = registers_mips[4]; // Algo desconozido aun
	assign wire_read_data_5 = registers_mips[5]; // Algo desconozido aun
	assign wire_read_data_6 = registers_mips[6]; // Algo desconozido aun
	assign wire_read_data_7 = registers_mips[7]; // Algo desconozido aun*/
	
	assign reg_jump_register = registers_mips[read_register_1];

	generate
		integer i;		
		initial
        for (i = 0; i < depth; i = i + 1)
          registers_mips[i] = i; // reg0 = 0. reg1 = 1. reg2 = 2... etc.
	endgenerate

	always @(posedge clk)
	begin
		if (reset)
		begin
			read_data_1 <= 0;
			read_data_2 <= 0;
		end

		else begin
			read_data_1 <= registers_mips[read_register_1];
			read_data_2 <= registers_mips[read_register_2];
		end
	end

	always @(negedge clk)
	begin
		if (RegWrite) 
		begin
			registers_mips[write_register] <= write_data;				
		end
	end

endmodule
