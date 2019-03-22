`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  LATCH, REGISTRO ENTRE ETAPA INSTRUCTION FETCH E INSTRUCTION DECODE
//////////////////////////////////////////////////////////////////////////////////

module IF_ID #(
	parameter len_data = 32,
	parameter len_addr = 7,
	parameter len_test = 8
	) (
	input clk,
	input reset,
	input [2:0] in_pc_src, // viene de la unidad de control
	input [len_data-1:0] in_pc_jump,
	input [len_data-1:0] in_pc_register,
	input [len_data-1:0] in_branch_address,
	input stall_flag,  

	input [len_addr-1:0] in_addr_debug,
	input debug_flag,
	input [len_data-1:0] in_ins_to_mem,
	input wea_ram_inst, 

	output reg [len_data-1:0] out_pc_branch,
	output [len_data-1:0] out_instruction,
	output [len_data-1:0] out_pc,
	output [len_test-1:0] out_inst_test,

	output reg out_halt_flag_if=0 // para debug
    );

    wire [len_data-1:0] conn_adder_pcmux;
    wire [len_data-1:0] conn_pcmux_pc;
    wire [len_data-1:0] conn_pc_adder_imem;

    wire [len_data-1:0] conn_out_instruction;
	

    wire connect_wire_douta;
    wire flush = in_pc_src[0];

	wire [len_data-1:0] conn_instruction_test;

    assign out_instruction = conn_out_instruction;
    assign out_pc = conn_pc_adder_imem;
	assign out_inst_test = conn_instruction_test[7:0];

	PC_MUX #(
		.len_data(len_data)
		)
		u_pc_mux(
            .PCSrc(in_pc_src),
            .adder_out(conn_adder_pcmux),
            .branch_address(in_branch_address),
			.jump_address(in_pc_jump),
			.register(in_pc_register),

            .pc_out(conn_pcmux_pc)
		); 

	PC_ADDER #(
		.len_addr(len_data)
		)
		u_pc_adder(
			.in_a(conn_pc_adder_imem),
			.adder_out(conn_adder_pcmux)
			); 

	PC #(
		.len_addr(len_data)
		)
		u_pc(
            .clk(~clk),
            .reset(reset),
            .PCWrite(~stall_flag),
			.adder_input((connect_wire_douta)?(conn_pc_adder_imem):(conn_pcmux_pc)),
			
            .pc_out(conn_pc_adder_imem)
		);

	INSTRUCTION_MEM #(
		.len_addr(len_addr),
      .len_data(len_data)
		)
		u_instruction_mem(
			.Wr(wea_ram_inst),
            .Addr(debug_flag ? in_addr_debug : conn_pc_adder_imem[len_addr-1:0]),
			.In_Data(in_ins_to_mem),

			.Data_test(conn_instruction_test),

            .Data(conn_out_instruction),
			.wire_douta(connect_wire_douta)
			); 

	initial
    begin
      	out_pc_branch <= 0;
		out_halt_flag_if <= 0;
    end

	always @(posedge clk, posedge reset) 
	begin
		if(reset) begin
			out_pc_branch <= 0;
			out_halt_flag_if <= 0;			
		end

		else begin
			out_halt_flag_if <= connect_wire_douta;

			if ((~stall_flag) | flush) 
			begin
				out_pc_branch <= (flush) ? {len_data{1'b 0}} : conn_adder_pcmux;
			end
		end
	end
	
endmodule
