`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: DATA PATH
//////////////////////////////////////////////////////////////////////////////////
module DATA_PATH
    #(
        parameter len_data = 16,
        parameter len_addr = 11,
        parameter len_mux_a = 2
    )
    (
        input clk,
        input reset,
        input [len_mux_a - 1 : 0] SelA,
        input SelB,
        input WrAcc,
        input Op,
        input [len_addr - 1 : 0] inst_operand,
        input [len_data - 1 : 0] Out_Data,         // Salida de DATA_MEM para los MUX

        output [len_addr - 1 : 0] Addr,            // Por si el inst_operand tiene una direccion en vez de un inmediato
        output [len_data - 1 : 0] In_Data          // Salida del ACC que se quiere guardar en DATA_MEM (en store)
    );

    wire [len_data - 1 : 0] conn_signExt_muxAB;
    wire [len_data - 1 : 0] conn_aluResult_muxA;
    wire [len_data - 1 : 0] conn_muxA_acc;
    wire [len_data - 1 : 0] conn_muxB_alu;
    wire [len_data - 1 : 0] conn_acc_alu;
    
    assign Addr = inst_operand;
    assign In_Data = conn_acc_alu;

    SIGNAL_EXTENSION #(
        .len_data(len_data),
        .len_addr(len_addr)
    )
        u_signal_extension
        (
            .inst_operand(inst_operand),

            .out_operand(conn_signExt_muxAB)
        );
    
    MUX_A #(
        .len_data(len_data),
        .len_mux_a(len_mux_a)
    )
        u_mux_a
        (
            .SelA(SelA),
            .inst_operand(conn_signExt_muxAB),
            .alu_result(conn_aluResult_muxA),
            .data_mem_out(Out_Data),

            .out(conn_muxA_acc)
        );

    MUX_B #(
        .len_data(len_data)
    )
        u_mux_b
        (
            .SelB(SelB),
            .inst_operand(conn_signExt_muxAB),
            .data_mem_out(Out_Data),

            .out(conn_muxB_alu)
        );

    ACC #(
        .len_data(len_data)
    )
        u_acc
        (
            .clk(clk),
            .reset(reset),
            .in(conn_muxA_acc),
            .ena(WrAcc),

            .out(conn_acc_alu)
        );

    ALU #(
        .len_data(len_data)
    )
        u_alu
        (
            .in_A(conn_acc_alu),
            .in_B(conn_muxB_alu),
            .Op(Op),

            .result(conn_aluResult_muxA)
        );
endmodule
