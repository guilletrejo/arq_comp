`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  LATCH, REGISTRO ENTRE ETAPA MEMORY Y WRITE BACK
//////////////////////////////////////////////////////////////////////////////////

module MEM_WB #(
	parameter len_data = 32,
	parameter num_bits = 5,//$clog2(len_data),
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
	)(
	input clk,
	input reset,
	input [len_data-1:0] in_addr_mem,
	input [len_data-1:0] write_data,
	input [len_mem_bus-1:0] memory_bus,
    input [len_wb_bus-1:0] in_writeBack_bus,
	input [num_bits-1:0] in_write_reg,	

	input zero_flag,
	input [len_data-1:0] in_pc_branch,
	input halt_flag_m,

	output reg [len_data-1:0] read_data,
	output pc_src,
	output [len_data-1:0] out_pc_branch,
    output reg [1:0] out_writeBack_bus,
	output reg [len_data-1:0] out_addr_mem,
	output reg [num_bits-1:0] out_write_reg,

	/* Para mandar a Debug Unit */
	output [len_data-1:0] data0,
	/* ------------------------ */	

	output reg out_halt_flag_m=0
    );

	wire 	MemWrite,
			MemRead,
			Branch,
			control_unsigned,
			control_LH,
			control_LB,
			control_SH,
			control_SB,
			BranchNotEqual;

	reg [len_data-1:0] 	connect_mux_in_mem;	
	wire [len_data-1:0]	conn_out_mem;
	wire [len_data-1:0]	conn_out_mem_debug;

	assign MemWrite			= memory_bus[0],
		   MemRead 			= memory_bus[1],
		   Branch   		= memory_bus[2],
		   control_unsigned = memory_bus[3],
		   control_LH 		= memory_bus[4],
		   control_LB 		= memory_bus[5],
		   control_SH 		= memory_bus[6],
		   control_SB 		= memory_bus[7],
		   BranchNotEqual   = memory_bus[8];

	assign out_pc_branch = in_pc_branch;
	assign pc_src = Branch && ((BranchNotEqual) ? (~zero_flag) : (zero_flag));	// la señal de Branch se activa con ambas intrucciones de branch, la otra señal te indica cual de las 2 fue

	/* Para mandar a Debug Unit */
	assign data0 = conn_out_mem_debug;
	/*------------------------ */	

	DATA_MEM #(
        .len_data(len_data)
		)
		u_data_mem(
            .clk(~clk),
            .Rd(MemRead),
            .Wr(MemWrite),
            .Addr(in_addr_mem[5:0]),
            .In_Data(connect_mux_in_mem),
		
			.Out_Data_debug(conn_out_mem_debug),
			.Out_Data(conn_out_mem)
			);

	initial
    begin
      	read_data <= 0;
		out_writeBack_bus <= 0;
		out_addr_mem <= 0;
		out_write_reg <= 0;
		out_halt_flag_m <= 0;
    end

	always @(posedge clk, posedge reset)
	begin

		if(reset)
		begin
			read_data <= 0;
		    out_writeBack_bus <= 0;
			out_addr_mem <= 0;
			out_write_reg <= 0;
			out_halt_flag_m <= 0;
		end

		else begin
			out_halt_flag_m <= halt_flag_m;

			out_writeBack_bus <= in_writeBack_bus;
			out_addr_mem <= in_addr_mem;
			out_write_reg <= in_write_reg;

			// para mostrar en debug unit
			//data0 <= conn_out_mem_debug;
			//

			if (control_LH) 
			begin
				if (control_unsigned) 
				begin
					read_data <= {{16{1'b 0}},conn_out_mem[15:0]};
				end
				else 
				begin
					read_data <= {{16{conn_out_mem[15]}},conn_out_mem[15:0]};				
				end
			end
			else if (control_LB) 
			begin
				if (control_unsigned) 
				begin
					read_data <= {{24{1'b 0}},conn_out_mem[7:0]};
				end
				else 
				begin
					read_data <= {{24{conn_out_mem[7]}},conn_out_mem[7:0]};				
				end
			end
			else 
			begin
				read_data <= conn_out_mem;				
			end
		end
	end

	always @(*)
	begin

		/* PROBAR ESTA NEGRADA EN EL IF SECUENCIAL. 
		   OTRA NEGRADA PARA PROBAR: ver data_mem*/
		/*if(in_addr_mem==0)
		begin
			data_0 <= conn_out_mem;
		end
		else
		begin
			data_0 <= 32'hffffffff;
		end*/

		if (control_SH) 
		begin
			connect_mux_in_mem <= {{16{write_data[15]}},write_data[15:0]};				
		end
		else if (control_SB) 
		begin
			connect_mux_in_mem <= {{24{write_data[7]}},write_data[7:0]};				
		end
		else 
		begin
			connect_mux_in_mem <= write_data;				
		end


	end

endmodule