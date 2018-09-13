`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2017 08:21:19 PM
// Design Name: 
// Module Name: receiver
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

`define NBIT_DATA_LEN 8

module RX
    ( 
		//input clk,    // ver para que?????
		//input reset,	// ver para que?????
		rx_bit,			// recepcion de bits
		tick,			// clock salida del baud_rate_gen
	
		// output
		rx_done_tick,	// fin de recepcion
		data_out		// datos recibidos y enviados a la interfaz
	); 

	parameter NBIT_DATA = `NBIT_DATA_LEN;	//largo del dato
	parameter LEN_DATA = 3;  //$clog2(NBIT_DATA); 
	parameter NUM_TICKS = 16;
	parameter LEN_NUM_TICKS = 4; //$clog2(NUM_TICKS); 

	input rx_bit;	// recepcion de bits
	input tick;	
	output reg rx_done_tick=1'b0;
	output [NBIT_DATA-1:0] data_out;
	
	// estados 
	localparam	[1:0] IDLE 	= 2'b 00;
	localparam	[1:0] START	= 2'b 01;
	localparam	[1:0] DATA	= 2'b 10;
	localparam	[1:0] STOP 	= 2'b 11;

	reg [1:0] state = IDLE;	
	reg [LEN_NUM_TICKS - 1:0] tick_counter = 0;
	reg [LEN_DATA - 1:0] num_bits = 0;
	reg [NBIT_DATA - 1:0] buffer;

	assign data_out = buffer; 

	always @(posedge tick) 
	begin
		case (state)
			IDLE : 
				if (~rx_bit) 	//bit de start
				begin 			
					state = START; 		//siguiente estado, inicio de recepcion
					tick_counter = 0; 
				end
			START :
				begin
					if (tick_counter==(NUM_TICKS>>1)-1) //cuento7 y me posiciono en el medio del bit
					begin 								
						state = DATA; 	//siguiente estado, primer bit de datos			
						tick_counter = 0; //comienzo a contar de nuevo
						num_bits = 0;	//cantidad de datos recibidos 
					end 
					else 
						tick_counter = tick_counter + 1;
                end
			
			DATA : 
				begin
					if (tick_counter==NUM_TICKS-1)//cuento15 y me posiciono en el medio del bit siguiente
					begin 
						tick_counter = 0;
						buffer = {rx_bit , buffer [NBIT_DATA-1 : 1]}; //actualizo el buffer con el bit recibido
						if (num_bits==(NBIT_DATA-1)) //veo cuantos bits del dato recibio
							state = STOP; //si recibi todos, el siguiente estado es el de stop
						else 
							num_bits = num_bits + 1;
					end 
					else
						tick_counter = tick_counter + 1;
			    end

			STOP : //no lee el valor bit de stop
				begin
					if (tick_counter==(NUM_TICKS-1)) //cuento15 y me posiciono en el medio del bit de stop
					begin 
						tick_counter = 0; 
						num_bits = 0;
						state = IDLE;  //vuelve a quedar a la espera de otro dato
						rx_done_tick =1'b 1; //avisa a la interfaz que termino
					end 
					else 
						tick_counter = tick_counter + 1;
                end
            default :
            begin
				state = IDLE; 
				tick_counter = 0; 
				num_bits = 0; 
				buffer = 0; // no sabemos si va en stop o no ????????????? parece que no che 
			end
        endcase
	end 
endmodule