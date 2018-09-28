`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2018 09:26:45 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define LEN_DATA 8

module TOP
(
	input CLK,
	input RX_INPUT,

	output TX_OUTPUT,
	output OSC
	//output [7:0] buffer_led
);

	//wire [`LEN_DATA-1 : 0]connect_A;
	//wire [`LEN_DATA-1 : 0]connect_B;
	//wire [1 : 0]connect_OPCODE;
	//wire [`LEN_DATA-1 : 0]connect_RESULT_OUT;
	wire [`LEN_DATA-1 : 0]win;
	wire [`LEN_DATA-1 : 0]winB;
	wire [`LEN_DATA-1 : 0]wout;
	wire [1 : 0]wopout;
	wire [`LEN_DATA-1 : 0]connect_data_tx;
	wire [`LEN_DATA-1 : 0]connect_data_rx;
	wire connect_tx_start;
	wire connect_rx_done_tick;
	wire connect_tx_done_tick;
   assign OSC= TX_OUTPUT;
	UART_echo #(
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
			
	/*ALU #(
		.lenghtIN(`LEN_DATA),
		.lenghtOP(6)
		)
		u_alu
		(
			.A(connect_A),
			.B(connect_B),
			.OPCODE(connect_OPCODE),
			.RESULT_OUT(connect_RESULT_OUT)  
	    );*/
		 
	t u_t
		(
			.in(win),
			.inB(winB),
			.inOp(wopout),
			.tout(wout)
	    );
			
	INTERFACE_echo #(
		.NBIT_DATA_LEN(`LEN_DATA)
		)
		u_interface 
		( 
		 	.rx_done_tick(connect_rx_done_tick),
		 	.rx_data_in(connect_data_rx),
		 	//.alu_data_in(connect_RESULT_OUT),
			.clk(CLK),
			.in(wout),
			
			.bout(winB),
			.aout(win),
			.opout(wopout),
		 	.tx_start(connect_tx_start),
			//.A(connect_A),
			//.B(connect_B),
			//.Op(connect_OPCODE),
		 	.data_out(connect_data_tx),
			.tx_done_tick(connect_tx_done_tick)
		); 


endmodule