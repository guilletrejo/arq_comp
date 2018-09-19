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
	//input clk,   //?
 	//input reset, //?
 	input rx_done_tick,  			  // fin de recepcion
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  // Dato del RX recibido
 	input [NBIT_DATA_LEN-1:0] alu_data_in, // Resultado de la ALU para pasarlo al TX 

 	output reg tx_start = 0,				// LA INTERFAZ le tiene que avisar a TX cuando empezar
	// registros para escribir en la ALU
	output reg [NBIT_DATA_LEN-1 : 0] A = 0,		
	output reg [NBIT_DATA_LEN-1 : 0] B = 0,
	output reg [5 : 0] OPCODE = 0,

	// para escribir en TX
 	output [NBIT_DATA_LEN-1:0] data_out  // = 0 ???? Ver si inicializar 
); 

	/* Para saber si esta recibiendo A, B, u OPCODE.
	   00 : recibiendo A.
	   01 : recibiendo B.
	   02 : recibiendo OPCODE.
	*/
	reg [1 : 0] counter_in = 2'b 00;
	// registros para escribir en la ALU
	assign data_out = alu_data_in;	// lo que recibe de la ALU lo tira a TX
	
	always @(*) 
	begin	 	
		if (rx_done_tick) 
			begin
				case (counter_in) // ver si hay que poner default si no compila sintacticamente
					2'b 00: A = rx_data_in;
					2'b 01: B = rx_data_in;
					2'b 10: OPCODE = rx_data_in;
				endcase		
				counter_in = counter_in + 1'b1;		
			end
	
		if (counter_in == 2'b 11)
			begin
				counter_in = 0; 			
				tx_start = 1'b1;
			end
		else
			begin
				tx_start = 1'b0;				
			end		
    end
endmodule
