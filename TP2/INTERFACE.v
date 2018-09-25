`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2018 08:23:13 PM
// Design Name: 
// Module Name: INTERFACE
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

module INTERFACE
#(
	parameter NBIT_DATA_LEN = 8 // # buffer bits 
) 
( 
	input clk,								// necesario para cambiar de estados
 	input rx_done_tick,  			  		// fin de recepcion
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	// Dato del RX recibido
 	input [NBIT_DATA_LEN-1:0] alu_data_in, 	// Resultado de la ALU para pasarlo al TX 
 	output reg tx_start = 0,				// LA INTERFAZ le tiene que avisar a TX cuando empezar
	// registros para escribir en la ALU
	output reg [NBIT_DATA_LEN-1 : 0] A = 0,		
	output reg [NBIT_DATA_LEN-1 : 0] B = 0,
	output reg [5 : 0] Op = 0,
	// para escribir en TX
 	output [NBIT_DATA_LEN-1:0] data_out  // = 0 ???? Ver si inicializar 
); 

	// estados 
	localparam	[1:0] receive_A 	= 2'b 00;
	localparam	[1:0] receive_B		= 2'b 01;
	localparam	[1:0] receive_Op	= 2'b 10;
	localparam	[1:0] send_result	= 2'b 11;

	reg [1:0] state = receive_A;

	// registros para escribir en la ALU
	assign data_out = alu_data_in;	// lo que recibe de la ALU lo tira a TX
	
	always @(posedge clk) 
	begin	 	
		if (rx_done_tick) 
			begin
				case (state)
					receive_A:
						begin
							A= rx_data_in;
							tx_start = 1'b0;
							state = receive_B;
						end
					receive_B:
						begin
							B= rx_data_in;
							tx_start = 1'b0;
							state = receive_Op;
						end
					receive_Op:
						begin
							Op= rx_data_in;
							tx_start = 1'b0;
							state = receive_Op;
						end
					send_result:
						begin
							tx_start = 1'b1;
							state=receive_A;
						end
					default:
						begin
							tx_start = 1'b0;
						end
				endcase	
			end
    end
endmodule
