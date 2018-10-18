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
`define len_trama 8
module TOP
    #(
        parameter len_mux_a = `len_mux_a,
        parameter len_addr = `len_addr,
        parameter len_data = `len_data,
        parameter init_file = `init_file,
        parameter ram_depth = `ram_depth,
		parameter len_opcode = `len_opcode,
		parameter len_trama = `len_trama
    )
    (
    input clk,
    input reset,
    input RX_INPUT,
    //input start,        // ahora para probar, debe ser un wire con la interfaz
	 
    output [len_trama-1:0] TX_OUTPUT,
	// output [len_data-1:0] acumulador,
	// output [len_trama-1:0] clk_count,
	output [len_trama-1:0] led_acc
    );

    wire [len_addr-1:0] conn_PROGRAM_MEM_Addr;
    wire [len_data-1:0] conn_Data;
    wire conn_Rd;
    wire conn_Wr;
    wire [len_addr-1:0] conn_DATA_MEM_Addr;
    wire [len_data-1:0] conn_Out_Data;
    wire [len_data-1:0] conn_In_Data;

    wire conn_cpu_start;
    wire conn_cpu_done;

    wire conn_tx_start;
    wire conn_rx_done_tick;
    wire conn_tx_done_tick;
    wire [len_trama-1:0] conn_tx_data;
    wire [len_trama-1:0] conn_rx_data;
    wire [len_trama-1:0] conn_clk_count;
	 
	//assign acumulador= conn_In_Data;
	assign led_acc = conn_clk_count;
	 
	CLK_COUNTER #(
        .len_counter(len_trama)
    )
        u_clk_counter(
            .clk(clk),
            .reset(reset),
            .start(conn_cpu_start),
            
            .count(clk_count)
        );

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
            .start(start),
            
            .PROG_MEM_Addr(conn_PROGRAM_MEM_Addr),
            .DATA_MEM_Addr(conn_DATA_MEM_Addr),
            .Wr(conn_Wr),
            .Rd(conn_Rd),
            .In_Data(conn_In_Data),
            .cpu_done(cpu_done)
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

    INTERFACE #(
        .NBIT_DATA_LEN(len_trama),
        .len_data(len_data)
    )
        u_interface(
            .in_clk_count(conn_clk_count),
            .in_acc(conn_In_Data),
            .clk(clk),
            .rx_done_tick(conn_rx_done_tick),
            .tx_done_tick(conn_tx_done_tick),
            .rx_data_in(conn_rx_data),
            .cpu_done(cpu_done),

            .cpu_start(conn_cpu_start),
            .tx_start(conn_tx_start),
            .data_out(conn_tx_data)
        );

    UART #(
		.NBIT_DATA(len_trama),
		.NUM_TICKS(16),
		.BAUD_RATE(9600)
		)
		u_uart
			(
				.CLK(clk),
				.tx_start(conn_tx_start),
				.rx_bit(RX_INPUT),
				.data_in(conn_tx_data),
			
				.data_out(conn_rx_data),
				.rx_done_tick(conn_rx_done_tick),
				.tx_bit(TX_OUTPUT),
				.tx_done_tick(conn_tx_done_tick)
			);


endmodule
