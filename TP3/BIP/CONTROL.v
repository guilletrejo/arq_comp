`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: CONTROL
//////////////////////////////////////////////////////////////////////////////////
module CONTROL
    #(
        parameter len_data = 16,
        parameter len_addr = 11,
        parameter len_mux_a = 2,
		parameter len_opcode = 5
    )
    (
        input clk,
        input reset,
        input [len_data-1:0] Data,
        input start,

        output [len_addr-1:0] Addr,
        output [len_mux_a-1:0] SelA,
        output SelB,
        output WrAcc,
        output Op,
        output WrRam,
        output RdRam,
        output [len_addr-1:0] Operand,
        output cpu_done
    );

    wire [len_addr-1:0] conn_pcout_adderin; //salida del pc, entrada del pc_adder
    wire [len_addr-1:0] conn_adderout_pcin; //salida del pc_adder, entrada del pc
    wire conn_WrPC;                         //enable del pc
    wire [len_addr-1:0]conn_Data_Operand;                 //operando que sale de la instruccion
    wire [len_opcode-1:0]conn_Data_Opcode;  //opcode que sale de la instruccion

    assign conn_Data_Operand = Data [len_addr-1:0]; 
    assign conn_Data_Opcode = Data [len_data-1:len_addr];
    assign Operand = conn_Data_Operand;
    assign Addr = conn_pcout_adderin;

    INSTRUCTION_DECODER #(
        .len_opcode(len_opcode),
        .len_mux_a(len_mux_a)
    )
        u_instruction_decoder(
            .Opcode(conn_Data_Opcode),
            
            .WrPC(conn_WrPC),
            .SelA(SelA),
            .SelB(SelB),
            .WrAcc(WrAcc),
            .Op(Op),
            .WrRam(WrRam),
            .RdRam(RdRam),
            .cpu_done(cpu_done)
        );
    
    PC #(
        .len_addr(len_addr)
    )
        u_pc(
            .clk(clk),
            .ena(conn_WrPC),
            .adder_input(conn_adderout_pcin),
            .reset(reset),
            .start(start),

            .pc_out(conn_pcout_adderin)
        );

    PC_ADDER #(
        .len_addr(len_addr),
        .sumando(1)
    )
        u_pc_adder(
            .pc_actual(conn_pcout_adderin),
            
            .adder_out(conn_adderout_pcin)
        );

endmodule
