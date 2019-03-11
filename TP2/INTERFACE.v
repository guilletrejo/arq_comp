`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: INTERFACE
//////////////////////////////////////////////////////////////////////////////////

module INTERFACE
#(
	parameter NBIT_DATA_LEN = 8, 		// buffer bits 
	parameter NBIT_OP_LEN   = 6  		// op bits 
) 
( 
	input [NBIT_DATA_LEN-1:0] in,    // Resultado de la ALU para pasarlo al TX 
	input clk,								// necesario para cambiar de estados
 	input rx_done_tick,  			  	// fin de recepcion
	input tx_done_tick,					// recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	// Dato del RX recibido

	// registros para escribir en la ALU
 	output reg [NBIT_DATA_LEN-1 : 0] aout,
	output reg [NBIT_DATA_LEN-1 : 0] bout,
	output reg [NBIT_OP_LEN-1   : 0] opout,
	
	// LA INTERFAZ le tiene que avisar a TX cuando empezar
	output reg tx_start = 0,				

	// para escribir en TX
 	output reg [NBIT_DATA_LEN-1:0] data_out,

	// para testear MIPS

	output [NBIT_DATA_LEN-1:0]test
); 

	// estados 
	localparam	[1:0] receive_A 	= 2'b 00;
	localparam	[1:0] receive_B	= 2'b 01;
	localparam	[1:0] receive_Op	= 2'b 10;
	localparam	[1:0] send_result	= 2'b 11;
	
	// registros internos
	reg [1:0] state = receive_A;
	reg [1:0] state_next = receive_A;
	reg reg_tx_done_tick;
	reg reg_rx_done_tick;
	
	reg [NBIT_DATA_LEN-1:0] reg_aout_next;
	reg [NBIT_DATA_LEN-1:0] reg_bout_next;
	reg [NBIT_OP_LEN-1  :0] reg_opout_next;
	reg [NBIT_DATA_LEN-1:0] reg_data_out_next;
	
	//para probar MIPS

	//assign test = rx_data_in;

	/* Logica de actualizacion de registros
	   (pasa lo que hay en la entrada a los reg)
		en cada pulso de clock.
	*/
	always @(posedge clk)
	begin
		reg_rx_done_tick <= rx_done_tick;
		reg_tx_done_tick <= tx_done_tick;
		state <= state_next;
		
		aout <= reg_aout_next;
		bout <= reg_bout_next;
		opout <= reg_opout_next;
		data_out <= reg_data_out_next;
		test <= rx_data_in;
	end
	
	/* Logica de actualizacion de estados.
		Actualiza si detecta un flanco ascendente en rx_done
		o en tx_done en el caso de send_result
	*/
	always @(*)
	begin
		
		case(state)
		
			receive_A:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						state_next = receive_B;
					end
					else
					begin
						state_next = receive_A;
					end
				end
		
			receive_B:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						state_next = receive_Op;
					end
					else
					begin
						state_next = receive_B;
					end
				end
		
			receive_Op:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						state_next = send_result;
					end
					else
					begin
						state_next = receive_Op;
					end
				end
				
			send_result:
				begin
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = receive_A;
					end
					else
					begin
						state_next = send_result;
					end
				end
		endcase
	end
	
	/* Logica de recepcion de datos de RX.
		(operandos, operador), y de envio de datos
		a TX (resultado).*/
	always @(*)
	begin

		case(state)
			
			receive_A:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = rx_data_in; // recibo A
				reg_bout_next = bout;
				reg_opout_next = opout;
			end
			
			receive_B:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = aout;
				reg_bout_next = rx_data_in; // recibo B
				reg_opout_next = opout;
			end
			
			receive_Op:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = aout;
				reg_bout_next = bout;
				reg_opout_next = rx_data_in; // recibo Op
			end
			
			send_result:
			begin
				tx_start = 1'b1;				  // habilito envio
				reg_data_out_next = in;		  // envio RESULT_OUT
				reg_aout_next = aout;
				reg_bout_next = bout;
				reg_opout_next = opout;
			end
	
		endcase
	end
endmodule
