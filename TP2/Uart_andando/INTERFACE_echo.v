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

module INTERFACE_echo
#(
	parameter NBIT_DATA_LEN = 8 // # buffer bits 
) 
( 
	input [NBIT_DATA_LEN-1:0] in,
	input clk,								// necesario para cambiar de estados
 	input rx_done_tick,  			  	// fin de recepcion
	input tx_done_tick,					// recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	// Dato del RX recibido
 	//input [NBIT_DATA_LEN-1:0] alu_data_in, 	// Resultado de la ALU para pasarlo al TX 
 	output reg [NBIT_DATA_LEN-1 : 0] aout,
	output reg [NBIT_DATA_LEN-1 : 0] bout,
	output reg [1: 0] opout,
	output reg tx_start = 0,				// LA INTERFAZ le tiene que avisar a TX cuando empezar
	// registros para escribir en la ALU
	//output reg [NBIT_DATA_LEN-1 : 0] A,		
	//output reg [NBIT_DATA_LEN-1 : 0] B,
	//output reg [1 : 0] Op,
	// para escribir en TX
 	output reg [NBIT_DATA_LEN-1:0] data_out   //= 0 ???? Ver si inicializar 
); 

	// estados 
	localparam	[1:0] receive_A 	= 2'b 00;
	localparam	[1:0] receive_B	= 2'b 01;
	localparam	[1:0] receive_Op	= 2'b 10;
	localparam	[1:0] receive		= 2'b 11;
	
	reg [1:0] state = receive;
	reg [1:0] state_next = receive;
	reg reg_tx_done_tick;
	reg reg_rx_done_tick;
	
	//reg [NBIT_DATA_LEN-1:0] reg_in_next;
	reg [NBIT_DATA_LEN-1:0] reg_aout_next;
	reg [NBIT_DATA_LEN-1:0] reg_bout_next;
	reg [1:0] reg_opout_next;
	reg [NBIT_DATA_LEN-1:0] reg_data_out_next;
	
	//reg mandar=0;
	
	always @(posedge clk)
	begin
		reg_rx_done_tick <= rx_done_tick;
		reg_tx_done_tick <= tx_done_tick;
		state <= state_next;
		
		aout <= reg_aout_next;
		bout <= reg_bout_next;
		opout <= reg_opout_next;
		data_out <= reg_data_out_next;
	end
	
	always @(*)
	begin
		
		case(state)
		
			receive:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						state_next = receive_A;
					end
					else
					begin
						state_next = receive;
					end
				end
		
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
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = receive;
					end
					else
					begin
						state_next = receive_Op;
					end
				end
				
		endcase
	end
	
	always @(*)
	begin
	
		case(state)
			
			receive:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = rx_data_in;
				reg_bout_next = bout;
				reg_opout_next = opout;
			end
			
			receive_A:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = aout;
				reg_bout_next = rx_data_in;
				reg_opout_next = opout;
			end
			
			receive_B:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
				reg_aout_next = aout;
				reg_bout_next = bout;
				reg_opout_next = rx_data_in;
			end
			
			receive_Op:
			begin
				tx_start = 1'b1;
				reg_data_out_next = in;
				reg_aout_next = aout;
				reg_bout_next = bout;
				reg_opout_next = opout;
			end
	
		endcase
		
	end
	
	// registros para escribir en la ALU
	//assign data_out = alu_data_in;	// lo que recibe de la ALU lo tira a TX
	
	
	/* Al poner aout = rx_data_in y bout = 10 
		antes de if mandar anda bien, se suma lo
		del operando que es lo ultimo que aparece
		en rx data in con un 2 binario.
		cuando pongo el aout = rx_data_in en el
		estado receive A deja de andar bien.
		Si pongo en el caso receive A un aout igual
		a cualquier numero se asigna bien y anda bien.
		el problema esta en cuando se hace en un estado
		A = rx_data_in porque parece que A no guarda el
		valor que tiene primero (primer operando) y lo
		deja asi quieto, sino que despues ese valor cambia.
		Habria que ver como hacer para que, la asignacion
		A = rx_data_in se haga una sola vez y ese primer valor que
		guarda en A quede para siempre en A y que A 
		no cambie su valor despues.
	always @(posedge clk) 
	begin
		//aout = rx_data_in;
		bout = 8'b00000010;
		if(mandar) //si termine de mandar o si aun no tengo todos los operandos
		begin
			tx_start=1'b1;
			mandar=0;
		end
		if(tx_done_tick) //si termine de mandar o si aun no tengo todos los operandos
		begin
			tx_start=1'b0;
		end
		if (rx_done_tick) 
			begin
				case (state)
					receive_A:
						begin
							tx_start = 1'b0;
							//aout = 8'b00111100;
							aout = rx_data_in;
							state = receive_B;
						end
					receive_B:
						begin
							tx_start = 1'b0;
							//B= rx_data_in;
							state = receive_Op;
						end
					receive_Op:
						begin
							tx_start = 1'b0;
						//	Op= rx_data_in;
							state=send_result;
						end
					send_result:
						begin
							tx_start = 1'b0;
							state=receive_A;
							mandar=1;
						end
					default:
						begin
							tx_start = 1'b0;
						end
				endcase	
			end
    end*/
endmodule
