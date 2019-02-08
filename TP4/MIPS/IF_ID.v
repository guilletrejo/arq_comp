`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  LATCH, REGISTRO ENTRE ETAPA INSTRUCTION FETCH E INSTRUCTION DECODE
//////////////////////////////////////////////////////////////////////////////////

module IF_ID #(
	parameter len = 32
	) (
	input clk,
	input reset,
	input in_pc_src, // viene de la unidad de control
	/*input [len-1:0] in_pc_jump,
	input [len-1:0] in_pc_register,*/
	input [len-1:0] in_branch_address,
	input stall_flag,  // ??

	/*input [len-1:0] in_addr_debug,
	input debug_flag,
	input [len-1:0] in_ins_to_mem,
	input wea_ram_inst,*/

	output [len-1:0] out_pc_branch,
	output [len-1:0] out_instruction,
	output [len-1:0] out_pc,
	output [len-1:0] out_adder
	//output reg out_halt_flag_if // para debug
    );

    wire [len-1:0] conn_adder_pcmux; 
    //wire [len-1:0] connect_mux_pc;
    wire [len-1:0] conn_pcmux_pc;
    wire [len-1:0] conn_pc_adder_imem;

    wire [len-1:0] conn_out_instruction;

    /*wire connect_wire_douta;
    wire flush = in_pc_src[0];*/

    assign out_instruction = conn_out_instruction;
    assign out_pc = conn_pc_adder_imem;
	assign out_pc_branch = conn_adder_pcmux;

	PC_MUX #(
		.len_data(len)
		)
		u_pc_mux(
            .PCSrc(in_pc_src),
            .adder_out(conn_adder_pcmux),
            .branch_address(in_branch_address),

            .pc_out(conn_pcmux_pc)
		); 

	PC #(
		.len_addr(len)
		)
		u_pc(
            .clk(clk),
            .reset(reset),
            .PCWrite(stall_flag), //ver eso despues, la stall flag no deberia estar negada? SEMANTICA
            .adder_input(conn_pcmux_pc),
			//.In((connect_wire_douta)?(connect_pc_sumador_mem):(connect_mux_pc)),
			
			
            .pc_out(conn_pc_adder_imem)
			);

	INSTRUCTION_MEM #(
		.len_addr(len),
        .len_data(len),
		.ram_depth(2048),
		.init_file("program32.hex")
		)
		u_instruction_mem(
			.clk(clk),
            .Addr(conn_pc_adder_imem),

            .Data(conn_out_instruction)
			//.reset(reset),
			//.ena(stall_flag),
			//.wea(wea_ram_inst),
			//.wire_douta(connect_wire_douta),
			//.flush(flush),
			//.douta(connect_out_instruction),
			//.dina(in_ins_to_mem)
			); 

	PC_ADDER #(
		.len_addr(len)
		)
		u_pc_adder(
			.in_a(conn_pc_adder_imem),
			.in_b(1),
			.adder_out(conn_adder_pcmux)
		); 


	/*always @(posedge clk, posedge reset) 
	begin
		if(reset) begin
			out_pc_branch <= 0;
			//out_halt_flag_if <= 0;			
		end

		else begin
			//out_halt_flag_if <= connect_wire_douta;

			if (stall_flag | flush) 
			begin
				out_pc_branch <= (flush) ? {len{1'b 0}} : connect_sumador_mux;
			end
		end
	end*/
	
endmodule
