`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: UART
//////////////////////////////////////////////////////////////////////////////////

module UART
#(
	parameter NBIT_DATA = 8,
	parameter NUM_TICKS = 16,
	parameter BAUD_RATE = 9600,
	parameter CLK_RATE = 100000000
)
(
	input CLK, 								  // clock de la FPGA
	input tx_start,
	input rx_bit,
	input [NBIT_DATA-1 : 0] data_in,   // entrada del TX desde la interfaz (interfaz escribe en TX)

	output [NBIT_DATA-1 : 0] data_out, // salida del RX que va hacia la interfaz (interfaz recibe de TX)
	output rx_done_tick,
	output tx_bit,
	output tx_done_tick
);

	wire connect_baud_rate_rx_tx; 

    BR_GEN #(.BAUD_RATE(BAUD_RATE), .CLK_RATE(CLK_RATE)) 
    br_gen (
    	.CLK(CLK),
    	.TICK(connect_baud_rate_rx_tx));

	RX #(.NBIT_DATA(NBIT_DATA), .NUM_TICKS(NUM_TICKS)) 
    rx (
		.clk(CLK),
		.rx_bit(rx_bit),
		.tick(connect_baud_rate_rx_tx),

		.rx_done_tick(rx_done_tick),
		.data_out(data_out)
		);

    TX #(.NBIT_DATA(NBIT_DATA), .NUM_TICKS(NUM_TICKS)) 
    tx (.clk(CLK),
		.tx_start(tx_start),
		.tick(connect_baud_rate_rx_tx),
		.data_in(data_in),

		.tx_done_tick(tx_done_tick),
		.tx_bit(tx_bit)
    	);
endmodule	
			