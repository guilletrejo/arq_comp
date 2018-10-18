`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: TOP DI TUTTI TOP
//////////////////////////////////////////////////////////////////////////////////
`define len_mux_a 2
`define len_addr 11
`define len_data 16
`define len_opcode 5
`define init_file "program.hex"
`define ram_depth 2048
module TOP
    #(
        parameter len_mux_a = `len_mux_a,
        parameter len_addr = `len_addr,
        parameter len_data = `len_data,
        parameter init_file = `init_file,
        parameter ram_depth = `ram_depth,
		parameter len_opcode = `len_opcode
    )
    (
    input clk,
    input reset,
	 
	 //output hola1,
	 output [len_data-1:0] acumulador,
	 //output [len_addr-1:0] pc,
	 output [7:0] led_acc
    );

    wire [len_addr-1:0] conn_PROGRAM_MEM_Addr;
    wire [len_data-1:0] conn_Data;
    wire conn_Rd;
    wire conn_Wr;
    wire [len_addr-1:0] conn_DATA_MEM_Addr;
    wire [len_data-1:0] conn_Out_Data;
    wire [len_data-1:0] conn_In_Data;
	 
	 //assign hola1= conn_Wr;
	 assign acumulador= conn_In_Data;
	 //assign pc= conn_PROGRAM_MEM_Addr;
	 assign led_acc = acumulador[7:0];

    CPU #(
        .len_data(len_data),
        .len_addr(len_addr),
        .len_mux_a(len_mux_a),
		.len_opcode(len_opcode)
    )
        u_cpu(
            .clk(clk),
            .reset(reset),
            .Data(conn_Data),
            .Out_Data(conn_Out_Data),
            
            .PROG_MEM_Addr(conn_PROGRAM_MEM_Addr),
            .DATA_MEM_Addr(conn_DATA_MEM_Addr),
            .Wr(conn_Wr),
            .Rd(conn_Rd),
            .In_Data(conn_In_Data)
        ); 

    PROGRAM_MEM #(
        .len_data(len_data),
        .len_addr(len_addr),
        .init_file(init_file),
        .ram_depth(ram_depth)
    )
        u_program_mem(
            .clk(clk),
            .Addr(conn_PROGRAM_MEM_Addr),

            .Data(conn_Data)
        ); 

    DATA_MEM #(
        .len_data(len_data),
        .len_addr(len_addr),
        .ram_depth(ram_depth)
    )
        u_data_mem(
            .clk(clk),
            .Rd(conn_Rd),
            .Wr(conn_Wr),
            .Addr(conn_DATA_MEM_Addr),
            .In_Data(conn_In_Data),

            .Out_Data(conn_Out_Data)
        );


endmodule
