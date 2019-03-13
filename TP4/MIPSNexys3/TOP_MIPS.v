`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  TOP MIPS
//////////////////////////////////////////////////////////////////////////////////

module TOP_MIPS#(
	parameter len_data = 32,
	parameter len_addr = 8,
	parameter num_bits = 5, //$clog2(len_data),
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2,
    parameter nb_Latches_1_2 = (len_data*1)/8,
    parameter nb_Latches_2_3 = (len_data*1)/8,
    parameter nb_Latches_3_4 = (len_data*1)/8,
    parameter nb_Latches_4_5 = (len_data*1)/8
	)(
	input clk,
	input reset,

	// para debug

	input debug_flag,
	//input [len_data-1:0] in_addr_debug, // para recolector, no usamos aun
	input [len_addr-1:0] in_addr_mem_inst,
	input [len_data-1:0] in_ins_to_mem,
	input wea_ram_inst,

	output [len_data-1:0] out_reg0_recolector,
	output [len_data-1:0] out_reg1_recolector,
	output [len_data-1:0] out_reg2_recolector,
	output [len_data-1:0] out_reg3_recolector,
	output [len_data-1:0] out_reg4_recolector,
	output [len_data-1:0] out_reg5_recolector,
	output [len_data-1:0] out_reg6_recolector,
	output [len_data-1:0] out_reg7_recolector,
	
	//test
	output [31:0] out_instruct,

	output [len_data-1:0] out_mem_wire,

	output [8-1:0] led_fpga,

	output [8-1:0] out_pc,
	output halt_flag
   /*output [32-1:0] Latches_1_2, // pensar la longitud pq queda demasiados cables
   output [32-1:0] Latches_2_3, // pensar la longitud pq queda demasiados cables
   output [32-1:0] Latches_3_4, // pensar la longitud pq queda demasiados cables
   output [32-1:0] Latches_4_5 // pensar la longitud pq queda demasiados cables*/
	);
	// input CLK100MHZ,
	// input SWITCH_RESET
 //    );    
 //    wire clk, reset;    
 //    assign clk = CLK100MHZ,
 //           reset = SWITCH_RESET; 

    wire [len_data-1:0] connect_in_pc_branch_1_2,
				   connect_in_pc_branch_2_3,
				   //connect_in_pc_branch_3_1, // la comentamos porque no se usa, el pcbranch pasa de 1-2-3-4 y vuelve a la 1
				   connect_in_pc_jump,
				   connect_in_pc_jump_register,
				   connect_instruccion,
				   connect_reg1,
				   connect_reg2,
				   connect_sign_extend,
				   connect_alu_out,
				   connect_write_data_5_2,
				   connect_read_data,
				   connect_out_addr_mem,
				   connect_write_data_3_4,
				   connect_in_pc_branch_3_4,
				   connect_in_pc_branch_4_1,
				   connect_reg0_recolector,
				   connect_reg1_recolector,
				   connect_reg2_recolector,
				   connect_reg3_recolector,
				   connect_reg4_recolector,
				   connect_reg5_recolector,
				   connect_reg6_recolector,
				   connect_reg7_recolector,
				   connect_out_mem_wire,
				   connect_out_pc;

	wire [num_bits-1:0] connect_rt,
						connect_rd,
						connect_rs,
						connect_shamt,
						connect_write_reg_3_4,
						connect_write_reg_4_2;

    wire [len_exec_bus-1:0] connect_execute_bus;
	
	wire [len_mem_bus-1:0] connect_memory_bus_2_3,
			   connect_memory_bus_3_4;
	
	wire [len_wb_bus-1:0] connect_writeBack_bus_2_3,
			   connect_out_writeBack_bus,
			   connect_writeBack_bus_3_4;
    
    wire connect_flag_jump,
         connect_flag_jump_register,
	     connect_zero_flag,
	     connect_branch_flag,
	     connect_stall_flag,
	     connect_halt_flag_1_2,
	     connect_halt_flag_2_3,
	     connect_halt_flag_3_4,
	     connect_halt_flag_4_5; 

	assign connect_write_data_5_2 = (connect_out_writeBack_bus[0]) ? connect_read_data : connect_out_addr_mem;
 	//assign connect_write_data_5_2 = connect_read_data; //no se soluciona con esto, por lo q el problema no es el MUX

	assign out_reg0_recolector = connect_reg0_recolector;
	assign out_reg1_recolector = connect_reg1_recolector;
	assign out_reg2_recolector = connect_reg2_recolector;
	assign out_reg3_recolector = connect_reg3_recolector;
	assign out_reg4_recolector = connect_reg4_recolector;
	assign out_reg5_recolector = connect_reg5_recolector;
	assign out_reg6_recolector = connect_reg6_recolector;
	assign out_reg7_recolector = connect_reg7_recolector;
	wire [32-1:0] conn_led_test;
	assign led_fpga = conn_led_test[7:0];
	assign out_mem_wire = connect_out_mem_wire; //[7:0];
	assign out_pc = connect_out_pc [7:0];
	assign halt_flag = connect_halt_flag_4_5;
	
	//test
	assign out_instruct = connect_instruccion;

	/*assign Latches_1_2 = {	// 2 registros			TOTAL 64 BITS
		connect_instruccion // 32 bits
		//connect_in_pc_branch_1_2 // 32 bits
	};
	assign Latches_2_3 = {	// 4 registros ...	TOTAL 128 BITS
		//{10{1'b 0}}, // 10 bits
		//connect_execute_bus, // 11 bits
		//connect_memory_bus_2_3, // 9 bits
		//connect_writeBack_bus_2_3, // 2 bits
		//{12{1'b 0}}, // 12 bits
		//connect_rd, // 5 bits
		//connect_rs, // 5 bits
		//connect_rt, // 5 bits
		//connect_shamt // 5 bits
		//connect_sign_extend // 32 bits
		connect_in_pc_branch_2_3 // 32 bits
	};
	assign Latches_3_4 = {	// 4 registros			TOTAL 128 BITS
		//{15{1'b 0}}, // 15 bits
		//connect_memory_bus_3_4, // 9 bits
		//connect_writeBack_bus_3_4, // 2 bits
		//connect_write_reg_3_4, // 5 bits
		//connect_zero_flag, // 1 bit
		//connect_alu_out // 32 bits
		//connect_in_pc_branch_3_4 // 32 bits
		connect_reg1 // 32 bits
	};
	assign Latches_4_5 = {	// 3 registroconnect_stall_flag BITS
		//{24{1'b 0}}, // 24 bits
		//connect_halt_flag_4_5, // 1 bitconnect_stall_flag
		//connect_write_reg_4_2, // 5 bits
		//connect_out_writeBack_bus, // 2 bits
		//connect_out_addr_mem // 32 bits
		//connect_read_data // 32 bits
		connect_reg2
	};*/

	IF_ID #(
		.len_data(len_data)
		)
		u_if_id(
			.clk(clk),
			.reset(reset),
			.in_pc_src({connect_flag_jump, connect_flag_jump_register, connect_branch_flag}),
			.in_pc_jump(connect_in_pc_jump),
			.in_branch_address(connect_in_pc_branch_4_1),
			.in_pc_register(connect_in_pc_jump_register),
			.stall_flag(connect_stall_flag),

			.in_addr_debug(in_addr_mem_inst),
			.debug_flag(debug_flag),
			.in_ins_to_mem(in_ins_to_mem),
			.wea_ram_inst(wea_ram_inst),

			.out_pc_branch(connect_in_pc_branch_1_2),
			.out_instruction(connect_instruccion),
			.out_pc(connect_out_pc), // para debug
			.out_halt_flag_if(connect_halt_flag_1_2) // para debug
		);

	ID_EX #(
		.len_data(len_data)
		)
		u_id_ex(
			.clk(clk),
			.reset(reset),
			.in_pc_branch(connect_in_pc_branch_1_2),
			.in_instruccion(connect_instruccion),

			.RegWrite(connect_out_writeBack_bus[1]),
			.write_data(connect_write_data_5_2),
			.write_register(connect_write_reg_4_2),
			.flush(connect_branch_flag),
			
			.out_pc_branch(connect_in_pc_branch_2_3),
			.out_pc_jump(connect_in_pc_jump),
			.out_pc_jump_register(connect_in_pc_jump_register),
			.out_reg1(connect_reg1),
			.out_reg2(connect_reg2),
			.out_sign_extend(connect_sign_extend),
			.out_rt(connect_rt),
			.out_rd(connect_rd),
			.out_rs(connect_rs),
			.out_shamt(connect_shamt),
			.out_test(conn_led_test),

			.out_reg0_recolector(connect_reg0_recolector),
			.out_reg1_recolector(connect_reg1_recolector),
			.out_reg2_recolector(connect_reg2_recolector),
			.out_reg3_recolector(connect_reg3_recolector),
			.out_reg4_recolector(connect_reg4_recolector),
			.out_reg5_recolector(connect_reg5_recolector),
			.out_reg6_recolector(connect_reg6_recolector),
			.out_reg7_recolector(connect_reg7_recolector),

			.execute_bus(connect_execute_bus),
			.flag_jump(connect_flag_jump),
			.flag_jump_register(connect_flag_jump_register),
			.memory_bus(connect_memory_bus_2_3),
			.writeBack_bus(connect_writeBack_bus_2_3),

			.stall_flag(connect_stall_flag),

			.halt_flag_d(connect_halt_flag_1_2),
			.out_halt_flag_d(connect_halt_flag_2_3)
		);

	EX_MEM #(
		.len_data(len_data)
		)
		u_ex_mem(
			.clk(clk),
			.reset(reset),
		
			.in_pc_branch(connect_in_pc_branch_2_3),
			.in_reg1(connect_reg1),
			.in_reg2(connect_reg2),
			.in_sign_extend(connect_sign_extend),
			.in_rt(connect_rt),
			.in_rd(connect_rd),
			.in_shamt(connect_shamt),
		
			.execute_bus(connect_execute_bus),
			.memory_bus(connect_memory_bus_2_3),
			.writeBack_bus(connect_writeBack_bus_2_3), 

			.ex_mem_reg_write(connect_writeBack_bus_3_4[1]),
			.mem_wb_reg_write(connect_out_writeBack_bus[1]),
			.ex_mem_rd(connect_write_reg_3_4),
			.mem_wb_rd(connect_write_reg_4_2),
			.in_rs(connect_rs),

			.in_mem_forw(connect_alu_out),
			.in_wb_forw(connect_write_data_5_2),
			.flush(connect_branch_flag),
		
			.out_pc_branch(connect_in_pc_branch_3_4),
			.out_alu(connect_alu_out),
			.zero_flag(connect_zero_flag),
			.out_reg2(connect_write_data_3_4),
			.out_write_reg(connect_write_reg_3_4),
		
			// señales de control
			.memory_bus_out(connect_memory_bus_3_4),
			.writeBack_bus_out(connect_writeBack_bus_3_4),

			.halt_flag_e(connect_halt_flag_2_3),
			.out_halt_flag_e(connect_halt_flag_3_4)
			);

	MEM_WB #(
		.len_data(len_data)
		)
		u_mem_wb(
			.clk(clk),
			.reset(reset),
			.in_addr_mem(connect_alu_out),
			.write_data(connect_write_data_3_4),
			
			.memory_bus(connect_memory_bus_3_4),
		    .in_writeBack_bus(connect_writeBack_bus_3_4),
			.in_write_reg(connect_write_reg_3_4),			
			.zero_flag(connect_zero_flag),
			.in_pc_branch(connect_in_pc_branch_3_4),
			.halt_flag_m(connect_halt_flag_3_4),

			//outputs		
			.read_data(connect_read_data),
			.pc_src(connect_branch_flag),
			.out_pc_branch(connect_in_pc_branch_4_1),
		    .out_writeBack_bus(connect_out_writeBack_bus),
			.out_addr_mem(connect_out_addr_mem),
			.out_write_reg(connect_write_reg_4_2),

			.out_mem_wire(connect_out_mem_wire), // para debug
			.out_halt_flag_m(connect_halt_flag_4_5)
			);

endmodule
