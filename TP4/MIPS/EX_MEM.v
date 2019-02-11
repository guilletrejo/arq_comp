`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  LATCH, REGISTRO ENTRE ETAPA EXECUTE Y MEMORY
//////////////////////////////////////////////////////////////////////////////////

module EX_MEM #(
	parameter len_data = 32,
	parameter num_bits = 5, //$clog2(len_data),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input clk,
	input reset,

	input [len_data-1:0] in_pc_branch,
	input [len_data-1:0] in_reg1,
	input [len_data-1:0] in_reg2,
	input [len_data-1:0] in_sign_extend,
	input [num_bits-1:0] in_rt,
	input [num_bits-1:0] in_rd,
	input [num_bits-1:0] in_shamt,

	input [len_exec_bus-1:0] execute_bus,
	input [len_mem_bus-1:0] memory_bus,
	input [len_wb_bus-1:0] writeBack_bus,

	// entradas para cortocircuito
	input ex_mem_reg_write,	// flag
	input mem_wb_reg_write,	// flag
	input [num_bits-1:0] ex_mem_rd,		// registro ya calculado, a forwardear
	input [num_bits-1:0] mem_wb_rd,		// registro ya calculado, a forwardear
	input [num_bits-1:0] in_rs,		// registro de instr siguiente que puede necesitar forwarding

	input [len_data-1:0] in_mem_forw,
	input [len_data-1:0] in_wb_forw,
	input flush,
	input halt_flag_e,
	
	output reg [len_data-1:0] out_pc_branch,
	output reg [len_data-1:0] out_alu,
	output reg zero_flag,
	output reg [len_data-1:0] out_reg2,
	output reg [num_bits-1:0] out_write_reg,

	output reg out_halt_flag_e,

	// señales de control
	output reg [len_mem_bus-1:0] memory_bus_out,
	output reg [len_wb_bus-1:0] writeBack_bus_out
    );

	wire [1:0] 	conn_forwarding_mux1,
				conn_forwarding_mux2;
				
    wire [len_data-1:0] 	mux1_alu_forwarding,
    				        mux2_alu_forwarding;

    /* a = b ? c : d ? e : f
        if b
          a = c
        else if d
          a = e
        else
          a = f
    */
	wire [len_data-1:0] conn_alu_inA = execute_bus[10] ? (in_pc_branch) : (execute_bus[7] ? ({{27{1'b 0}}, in_shamt}) : mux1_alu_forwarding);
	wire [len_data-1:0] conn_alu_inB = execute_bus[10] ? (1'b 1) : (execute_bus[6] ? in_sign_extend : mux2_alu_forwarding);
	wire [len_data-1:0] conn_alu_out;
	wire conn_zero_flag;

	ALU #(
		.len_data(32),
		.len_op(4)
		)
		u_alu(
			.inA(conn_alu_inA),
			.inB(conn_alu_inB),
			.inOp(execute_bus[3:0]),
	
			.RESULT_OUT(conn_alu_out),
			.zero_flag(conn_zero_flag)
		);

	FORWARDING_UNIT #(
        .num_bits(5)
		)
		u_forwarding_unit(
			.ex_mem_reg_write(ex_mem_reg_write),	// flag
			.mem_wb_reg_write(mem_wb_reg_write),	// flag
			.ex_mem_rd(ex_mem_rd),		// registro ya calculado, a forwardear
			.mem_wb_rd(mem_wb_rd),		// registro ya calculado, a forwardear
			.id_ex_rs(in_rs),		// registro de instr siguiente que puede necesitar forwarding
			.id_ex_rt(in_rt),		// registro de instr siguiente que puede necesitar forwarding

			.forwarding_muxA(conn_forwarding_mux1),
			.forwarding_muxB(conn_forwarding_mux2)
		);

	FORWARDING_MUX #(
        .len_data(32)
        )
		u_forwarding_mux1(
			.in_reg(in_reg1),			//entrada desde registros
			.in_mem_forw(in_mem_forw),	//salida de alu de clock anterior
			.in_wb_forw(in_wb_forw),	//salida del mux final de writeback
			.select(conn_forwarding_mux1),
			.out_mux(mux1_alu_forwarding)
			);
	
	FORWARDING_MUX #(
        .len_data(32)
        )
		u_forwarding_mux2(
			.in_reg(in_reg2),			//entrada desde registros
			.in_mem_forw(in_mem_forw),	//salida de alu de clock anterior
			.in_wb_forw(in_wb_forw),	//salida del mux final de writeback
			.select(conn_forwarding_mux2),
			.out_mux(mux2_alu_forwarding)
			);

	always @(negedge clk, posedge reset) 
	begin
		if (reset) begin
			out_pc_branch <= 0;
			out_alu <= 0;
			zero_flag <= 0;
			out_reg2 <= 0;
			out_write_reg <= 0;
			memory_bus_out <= 0;
			writeBack_bus_out <= 0;
			out_halt_flag_e <= 0;			
		end

		else begin
			out_halt_flag_e <= halt_flag_e;

			if (flush) 
			begin
				memory_bus_out <= 0;
				writeBack_bus_out <= 0;
				out_pc_branch <= 0;
				out_alu <= 0;
				out_reg2 <= 0;
				out_write_reg <= 0;
				zero_flag <= 0;
			end
			else
			begin		
				memory_bus_out <= memory_bus;
				writeBack_bus_out <= writeBack_bus;
				out_pc_branch <= in_pc_branch + in_sign_extend;
				out_alu <= conn_alu_out;
				out_reg2 <= in_reg2;
				out_write_reg <= execute_bus[9] ? (5'b 11111) : (execute_bus[8] ? in_rd : in_rt);
				zero_flag <= conn_zero_flag;
			end
		end
	end

endmodule