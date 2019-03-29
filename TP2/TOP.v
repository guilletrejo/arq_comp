`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: TOP
//////////////////////////////////////////////////////////////////////////////////

`define LEN_DATA 8
`define LEN_OP	  6

module TOP
(
	input CLK,
	input RX_INPUT,

	output TX_OUTPUT,
	output [LEN_DATA-1:0]led_fpga
);

	wire [`LEN_DATA-1 : 0] connect_A;
	wire [`LEN_DATA-1 : 0] connect_B;
	wire [`LEN_DATA-1 : 0] connect_RESULT_OUT;
	wire [`LEN_OP - 1 : 0] connect_Op;
	wire [`LEN_DATA-1 : 0] connect_data_tx;
	wire [`LEN_DATA-1 : 0] connect_data_rx;
	
	wire connect_tx_start;
	wire connect_rx_done_tick;
	wire connect_tx_done_tick;
	wire [LEN_DATA-1:0] conn_led;

  assign led_fpga = conn_led;
	
	UART #(
		.NBIT_DATA(`LEN_DATA),
		.NUM_TICKS(16),
		.BAUD_RATE(9600)
		)
		u_uart
			(
				.CLK(CLK),
				.tx_start(connect_tx_start),
				.rx_bit(RX_INPUT),
				.data_in(connect_data_tx),
			
				.data_out(connect_data_rx),
				.rx_done_tick(connect_rx_done_tick),
				.tx_bit(TX_OUTPUT),
				.tx_done_tick(connect_tx_done_tick)
			);
		 
	ALU #(
		.lenghtIN(`LEN_DATA),
		.lenghtOP(`LEN_OP)
		)
		u_alu
		(
			.inA(connect_A),
			.inB(connect_B),
			.inOp(connect_Op),
			
			.RESULT_OUT(connect_RESULT_OUT)
	    );
			
	INTERFACE #(
		.NBIT_DATA_LEN(`LEN_DATA)
		)
		u_interface 
		( 
		 	.rx_done_tick(connect_rx_done_tick),
		 	.rx_data_in(connect_data_rx),
			.clk(CLK),
			.in(connect_RESULT_OUT),
			
			.bout(connect_B),
			.aout(connect_A),
			.opout(connect_Op),
		 	.tx_start(connect_tx_start),
		 	.data_out(connect_data_tx),
			.test (conn_led),
			.tx_done_tick(connect_tx_done_tick)
		); 


endmodule