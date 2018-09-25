`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2017 04:36:02 PM
// Design Name: 
// Module Name: uart
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

module uart
#(
	parameter NBIT_DATA = 8,
	parameter NUM_TICKS = 16,
	parameter BAUD_RATE = 9600,
	parameter CLK_RATE = 50000000
)
(
	input CLK, 	// clock de la FPGA
	//input reset, // ver para queeeeeeeeeeeeeeee
	
	input rx_bit,	// LO QUE RECIBE TX (DE LA COMPU)

	output tx_bit,	// LO QUE SALE DE TX AL EXTERIOR (ECHO)
	output [7:0]buffer_led
	//output tx_done_tick
);

	wire [NBIT_DATA-1 : 0] buffer_tx_rx_echo;	// salida del RX a TX y entrada del TX desde RX
	wire rx_done_tick_tx_start;					// fin de recepcion para RX e inicio de transmision para TX
	wire connect_baud_rate_rx_tx;
	assign buffer_led=buffer_tx_rx_echo;
    BR_GEN_echo #(.BAUD_RATE(BAUD_RATE), .CLK_RATE(CLK_RATE)) 
    br_gen (
    	.CLK(CLK),
    	.TICK(connect_baud_rate_rx_tx));

	RX_echo #(.NBIT_DATA(NBIT_DATA), .NUM_TICKS(NUM_TICKS)) 
    rx (
		.clk(CLK),
		.rx_bit(rx_bit),
		.tick(connect_baud_rate_rx_tx),
		//.success_led(success_led),
		.rx_done_tick(rx_done_tick_tx_start),
		.data_out(buffer_tx_rx_echo)
		);

    TX_echo #(.NBIT_DATA(NBIT_DATA), .NUM_TICKS(NUM_TICKS)) 
    tx (.clk(CLK),
		//.reset(reset),
		.tx_start(rx_done_tick_tx_start),
		.tick(connect_baud_rate_rx_tx),
		.data_in(buffer_tx_rx_echo),
		

		//.tx_done_tick(tx_done_tick),
		.tx_bit(tx_bit)
    	);
endmodule	
			