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
	parameter len_data		= 16	// bits del acumulador
) 
( 
	input [NBIT_DATA_LEN-1:0] in_clk_count,  	// Dato del CPU (CLK) para pasarlo al TX
	input [len_data-1:0] in_acc, 				// Dato del CPU (ACC) para pasarlo al TX
	input clk,										// necesario para cambiar de estados
 	input rx_done_tick,  			  			// fin de recepcion
	input tx_done_tick,							// recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	// Dato del RX recibido (si recibe un 1, significa CPU, START!)
	input cpu_done,								// indica si cpu termino
	input reset,
	//registros para escribir en la CPU
 	output reg cpu_start,
	//output reg cpu_reset,
	
	// LA INTERFAZ le tiene que avisar a TX cuando empezar
	output reg tx_start = 0,

	// para escribir en TX (para mandar ACC1, ACC2 y CLK)
 	output reg [NBIT_DATA_LEN-1:0] data_out  
); 

	// estados 
	localparam	[2:0] RECEIVE 	= 3'b 000;
	localparam  [2:0] PROCESSING = 3'b 001;
	localparam	[2:0] SEND_ACC1	= 3'b 010;
	localparam	[2:0] SEND_ACC2	= 3'b 011;
	localparam	[2:0] SEND_CLK	= 3'b 100;
	
	// registros internos
	reg [2:0] state = RECEIVE;
	reg [2:0] state_next = RECEIVE;
	reg reg_tx_done_tick;
	reg reg_rx_done_tick;
	
	reg reg_cpu_start_next;
	//reg reg_cpu_reset_next;
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
		//cpu_reset <= reg_cpu_reset_next;
		data_out  <= reg_data_out_next;
		if(reset)
		begin
			state<=RECEIVE;
		end
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
						state_next = PROCESSING;
					end
					else
					begin
						state_next = RECEIVE;
					end
				end

			PROCESSING:
				begin
					if(cpu_done == 1) 
					begin
						state_next = SEND_ACC1;
					end
					else
					begin
						state_next = PROCESSING;
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
			default:
				begin
					state_next = RECEIVE;
				end
		endcase
	end
	
	/* Logica de recepcion de datos de RX.
		(bit de inicio para CPU -> cpu_start), y de envio de datos
		a TX (ACC y CLK).
	*/
	always @(*)
	begin

		case(state)
			
			RECEIVE:
			begin
				tx_start = 1'b0;
				reg_data_out_next  = data_out;
				reg_cpu_start_next = rx_data_in[0]; // recibo cpu_start
				//reg_cpu_reset_next = reg_cpu_reset_next[1]; // recibo cpu_reset
			end

			PROCESSING:
			begin
				tx_start = 1'b0;
				reg_cpu_start_next = rx_data_in[1];
				//reg_cpu_reset_next = 1'b0;
				reg_data_out_next  = data_out;
			end
			
			SEND_ACC1:
			begin
				tx_start = 1'b1;					// habilito envio
				reg_data_out_next = in_acc[7:0];	// envio ACC1
				reg_cpu_start_next = rx_data_in[1];
			end
			
			SEND_ACC2:
			begin
				tx_start = 1'b1;				// habilito envio
				reg_data_out_next = in_acc[15:8];			// envio ACC2
				reg_cpu_start_next = rx_data_in[1];
			end
			
			SEND_CLK:
			begin
				tx_start = 1'b1;			  // habilito envio
				reg_data_out_next = in_clk_count;		  // envio CLK
				reg_cpu_start_next = rx_data_in[1];
			end
			
			default:
			begin
				tx_start = 1'b0;			  // habilito envio
				reg_data_out_next = data_out;		  // envio CLK
				reg_cpu_start_next = rx_data_in[1];
			end
	
		endcase
	end
endmodule
