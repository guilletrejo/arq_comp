`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  LATCH, REGISTRO ENTRE ETAPA INSTRUCTION DECODE Y EXECUTION
//////////////////////////////////////////////////////////////////////////////////

module ID_EX #(
	parameter len_data = 32,
	parameter num_bits = 5,//$clog2(len_data),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input clk,
	input reset,
	input [len_data-1:0] in_pc_branch, // para tener PC+4 cuando necesite sumar el offset de un branch
	input [len_data-1:0] in_instruccion,
	input RegWrite,
	input [len_data-1:0] write_data,      // estos vienen 
	input [num_bits-1:0] write_register,  // de la etapa write back
	input flush,                          // para introducir una burbuja
	input halt_flag_d,                    // parar el procesador (debug)

	output reg [len_data-1:0] out_pc_branch,
	output [len_data-1:0] out_pc_jump,	         
	output [len_data-1:0] out_pc_jump_register,	 // pa debug
	output [len_data-1:0] out_reg1,
	output [len_data-1:0] out_reg2,
	output reg [len_data-1:0] out_sign_extend,   // para convertir el valor inmediato (16 bits) en 32 bits signados
	output reg [num_bits-1:0] out_rt,
	output reg [num_bits-1:0] out_rd,
	output reg [num_bits-1:0] out_rs,
	output reg [num_bits-1:0] out_shamt,         // shamt = SHIT AMOUNT

	//output [len_data-1:0] out_reg0_recolector,	// para recolector en modo debug
	output [len_data-1:0] out_reg1_recolector,	// para recolector en modo debug
	/*output [len_data-1:0] out_reg2_recolector,	// para recolector en modo debug
	output [len_data-1:0] out_reg3_recolector,	// para recolector en modo debug
	output [len_data-1:0] out_reg4_recolector,	// para recolector en modo debug
	output [len_data-1:0] out_reg5_recolector,	// para recolector en modo debug
	output [len_data-1:0] out_reg6_recolector,	// para recolector en modo debug
	output [len_data-1:0] out_reg7_recolector,	// para recolector en modo debug*/
	
	output reg out_halt_flag_d,

	// señales de control
	output flag_jump,
	output flag_jump_register,
	output reg [len_exec_bus-1:0] execute_bus,
	output reg [len_mem_bus-1:0] memory_bus,
	output reg [len_wb_bus-1:0] writeBack_bus,

	//señal de control de riesgos
	output stall_flag
    );

	wire [len_exec_bus-1:0] connect_execute_bus;
	wire [len_mem_bus-1:0] connect_memory_bus ;
	wire [len_wb_bus-1:0] connect_writeBack_bus;	

	wire [len_data-1:0]		connect_reg_jump_register,
							connect_out_reg1,
							connect_out_reg2,
								//connect_out_wire_reg0,
								connect_out_wire_reg1;
								/*connect_out_wire_reg2,
								connect_out_wire_reg3,
								connect_out_wire_reg4,
								connect_out_wire_reg5,
								connect_out_wire_reg6,
								connect_out_wire_reg7;*/


    wire mux_control;
    wire [(len_exec_bus+len_wb_bus+len_mem_bus)-1:0] mux_out = mux_control ? (1'b0) : {connect_execute_bus, connect_memory_bus, connect_writeBack_bus};

	assign flag_jump = (flush) ? (1'b0) : (connect_execute_bus[5]);
	assign flag_jump_register = (flush) ? (1'b0) : (connect_execute_bus[4]);
	
	assign out_pc_jump = (flush) ? (1'b0) : ({in_pc_branch[31:28], {2'b 00, (in_instruccion[25:0])}}); // para que es el out_pc_jump???
	assign out_pc_jump_register = (flush) ? (1'b0) : (connect_reg_jump_register);

	//assign out_reg0_recolector = connect_out_wire_reg0; // para recolector en modo debug
	assign out_reg1_recolector = connect_out_wire_reg1; // para recolector en modo debug
	/*assign out_reg2_recolector = connect_out_wire_reg2; // para recolector en modo debug
	assign out_reg3_recolector = connect_out_wire_reg3; // para recolector en modo debug
	assign out_reg4_recolector = connect_out_wire_reg4; // para recolector en modo debug
	assign out_reg5_recolector = connect_out_wire_reg5; // para recolector en modo debug
	assign out_reg6_recolector = connect_out_wire_reg6; // para recolector en modo debug
	assign out_reg7_recolector = connect_out_wire_reg7; // para recolector en modo debug*/
	
	
    assign out_reg1 = (flush) ? (1'b0) : (connect_out_reg1); 
    assign out_reg2 = (flush) ? (1'b0) : (connect_out_reg2);

    assign stall_flag = (flush) ? (1'b0) : (mux_control);

	CONTROL
		u_control(
			.opcode(in_instruccion[31:26]),
			.opcode_lsb(in_instruccion[5:0]),

            .execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus),
			.writeBack_bus(connect_writeBack_bus)
		);

	REGISTERS #(
		.len_data(32),
		.depth(32),
		.num_bits(5)
		)
		u_registers(
			.clk(clk),
			.reset(reset),
			.RegWrite(RegWrite),
			.read_register_1(in_instruccion[25:21]),
			.read_register_2(in_instruccion[20:16]),
			.write_register(write_register),
			.write_data(write_data),

			//.wire_read_data_0(connect_out_wire_reg0),
			.wire_read_data_1(connect_out_wire_reg1),
			/*.wire_read_data_2(connect_out_wire_reg2),
			.wire_read_data_3(connect_out_wire_reg3),
			.wire_read_data_4(connect_out_wire_reg4),
			.wire_read_data_5(connect_out_wire_reg5),
			.wire_read_data_6(connect_out_wire_reg6),
			.wire_read_data_7(connect_out_wire_reg7),*/
			.reg_jump_register(connect_reg_jump_register),
			.read_data_1(connect_out_reg1),
			.read_data_2(connect_out_reg2)
		);

	HAZARD_DU #(
        .num_bits(5)
		)
		u_hazard_du(
			.id_ex_mem_read(memory_bus[1]),
			.id_ex_rt(out_rt),
			.if_id_rs(in_instruccion [25:21]),
			.if_id_rt(in_instruccion [20:16]),

			.stall_flag(mux_control)
		);

	always @(negedge clk, posedge reset) 
	begin
		if (reset) begin
			out_pc_branch <= 0;
			out_sign_extend <= 0;
			out_rt <= 0;
			out_rd <= 0;
			out_rs <= 0;
			out_shamt <= 0;
			execute_bus <= 0;
			memory_bus <= 0;
			writeBack_bus <= 0;
			out_halt_flag_d <= 0;
		end

		else begin
			out_halt_flag_d <= halt_flag_d;

			if(flush)
			begin
				out_pc_branch <= 0;
				out_sign_extend <= 0;
				out_rt <= 0;
				out_rd <= 0;
				out_rs <= 0;
				out_shamt <= 0;
				execute_bus <= 0;
				memory_bus <= 0;
				writeBack_bus <= 0;
			end
			else 
			begin			
				out_pc_branch <= in_pc_branch;
				out_sign_extend <= $signed(in_instruccion[15:0]);
				out_rt <= in_instruccion [20:16];
				out_rd <= in_instruccion [15:11];
				out_rs <= in_instruccion [25:21];
				out_shamt <= in_instruccion [10:6];
				execute_bus <= mux_out[(len_mem_bus+len_wb_bus+len_exec_bus)-1:len_mem_bus+len_wb_bus];
				memory_bus <= mux_out[(len_mem_bus+len_wb_bus)-1:len_wb_bus];
				writeBack_bus <= mux_out[len_wb_bus-1:0];		
			end	
		end
	end

endmodule