`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/23/2017 09:26:45 PM
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

	output TX_OUTPUT
);

	wire [`LEN_DATA-1 : 0]connect_A;
	wire [`LEN_DATA-1 : 0]connect_B;
	wire [5 : 0]connect_OPCODE;
	wire [`LEN_DATA-1 : 0]connect_RESULT_OUT;
	wire [`LEN_DATA-1 : 0]connect_data_tx;
	wire [`LEN_DATA-1 : 0]connect_data_rx;
	wire connect_tx_start;
	wire connect_rx_done_tick;
    
	uart #(
		.NBITS(`LEN_DATA),
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
				.tx_done_tick()
			);
			
	alu #(
		.lenghtIN(`LEN_DATA),
		.lenghtOP(6)
		)
		u_alu
		(
			.A(connect_A),
			.B(connect_B),
			.Op(connect_OPCODE),
			.out(connect_RESULT_OUT)  
	    );
	
	interface_circuit #(
		.LEN_DATA(`LEN_DATA)
		)
		u_interface_circuit 
		( 
		 	.rx_done_tick(connect_rx_done_tick),
		 	.rx_data_in(connect_data_rx),
		 	.alu_data_in(connect_RESULT_OUT),
		
		 	.tx_start(connect_tx_start),
			.A(connect_A),
			.B(connect_B),
			.Op(connect_OPCODE),
		 	.data_out(connect_data_tx) 
		); 

endmodule