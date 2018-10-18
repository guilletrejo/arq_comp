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
	input [NBIT_DATA_LEN-1:0] in,    		// Dato del CPU (ACC1, ACC2, y CLK) para pasarlo al TX 
	input clk,								// necesario para cambiar de estados
 	input rx_done_tick,  			  		// fin de recepcion
	input tx_done_tick,						// recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	// Dato del RX recibido (si recibe un 1, significa CPU, START!)

	//registros para escribir en la CPU
 	output reg [NBIT_DATA_LEN-1 : 0] cpu_start,
	
	// LA INTERFAZ le tiene que avisar a TX cuando empezar
	output reg tx_start = 0,

	// para escribir en TX (para mandar ACC1, ACC2 y CLK)
 	output reg [NBIT_DATA_LEN-1:0] data_out  
); 

	// estados 
	localparam	[1:0] RECEIVE 	= 2'b 00;
	localparam	[1:0] SEND_ACC1	= 2'b 01;
	localparam	[1:0] SEND_ACC2	= 2'b 10;
	localparam	[1:0] SEND_CLK	= 2'b 11;
	
	// registros internos
	reg [1:0] state = RECEIVE;
	reg [1:0] state_next = RECEIVE;
	reg reg_tx_done_tick;
	reg reg_rx_done_tick;
	
	reg [NBIT_DATA_LEN-1:0] reg_cpu_start_next;
	reg [NBIT_DATA_LEN-1:0] reg_data_out_next;
	
	
	/* Logica de actualizacion de registros
	   (pasa lo que hay en la entrada a los reg)
		en cada pulso de clock.
	*/
	always @(posedge clk)
	begin
		reg_rx_done_tick <= rx_done_tick;
		reg_tx_done_tick <= tx_done_tick;
		state <= state_next;
		
		cpu_start <= reg_cpu_start_next;
		data_out  <= reg_data_out_next;
	end
	
	/* Logica de actualizacion de estados.
		Actualiza si detecta un flanco ascendente en rx_done para el caso RECEIVE
		o en tx_done en el caso de SEND_ACC1, SEND_ACC2 y SEND_CLK
	*/
	always @(*)
	begin
		
		case(state)
		
			RECEIVE:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						state_next = SEND_ACC1;
					end
					else
					begin
						state_next = RECEIVE;
					end
				end
		
			SEND_ACC1:
				begin
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = SEND_ACC2;
					end
					else
					begin
						state_next = SEND_ACC1;
					end
				end
		
			SEND_ACC2:
				begin
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = SEND_CLK;
					end
					else
					begin
						state_next = SEND_ACC2;
					end
				end
				
			SEND_CLK:
				begin
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = RECEIVE;
					end
					else
					begin
						state_next = SEND_CLK;
					end
				end
		endcase
	end
	
	/* Logica de recepcion de datos de RX.
		(bit de inicio para CPU -> cpu_s), y de envio de datos
		a TX (resultado).*/
	always @(*)
	begin

		case(state)
			
			RECEIVE:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = rx_data_in; // recibo A
				reg_bout_next = bout;
				reg_opout_next = opout;
			end
			
			SEND_ACC1:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = aout;
				reg_bout_next = rx_data_in; // recibo B
				reg_opout_next = opout;
			end
			
			SEND_ACC2:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = aout;
				reg_bout_next = bout;
				reg_opout_next = rx_data_in; // recibo Op
			end
			
			SEND_CLK:
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
