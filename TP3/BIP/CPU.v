`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//			     Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: CPU
//////////////////////////////////////////////////////////////////////////////////
module CPU
    #(
        parameter len_data = 16,
        parameter len_addr = 11,
        parameter len_opcode = 5,
        parameter len_mux_a = 2
    )
    (
        input clk,
        input reset,
        input [len_data - 1 : 0] Data,      // Instruccion de PROGRAM_MEM
        input [len_data - 1 : 0] Out_Data,  // Dato de DATA_MEM
        input start,

        output [len_addr - 1 : 0] PROG_MEM_Addr, 
        output [len_addr - 1 : 0] DATA_MEM_Addr,
        output Rd,
        output Wr,
        output [len_data - 1 : 0] In_Data,   // Para escribir un dato en memoria
        output cpu_done
    );

    wire [len_mux_a - 1 : 0] conn_SelA;
    wire conn_SelB;
    wire conn_WrAcc;
    wire conn_Op;
    wire [len_addr - 1 : 0] conn_inst_operand;

    CONTROL #(
        .len_data(len_data),
        .len_addr(len_addr),
        .len_mux_a(len_mux_a),
        .len_opcode(len_opcode)
    )
        u_control(
            .clk(clk),
            .reset(reset),
            .Data(Data),
				.start(start),

            .Addr(PROG_MEM_Addr),
            .SelA(conn_SelA),
            .SelB(conn_SelB),
            .WrAcc(conn_WrAcc),
            .Op(conn_Op),
            .WrRam(Wr),
            .RdRam(Rd),
            .Operand(conn_inst_operand),
            .cpu_done(cpu_done)
        );

    DATA_PATH #(
        .len_data(len_data),
        .len_addr(len_addr),
        .len_mux_a(len_mux_a)
    )
        u_datapath(
            .clk(clk),
            .reset(reset),
            .SelA(conn_SelA),
            .SelB(conn_SelB),
            .WrAcc(conn_WrAcc),
            .Op(conn_Op),
            .inst_operand(conn_inst_operand),
            .Out_Data(Out_Data),

            .Addr(DATA_MEM_Addr),
            .In_Data(In_Data)
            );

endmodule
