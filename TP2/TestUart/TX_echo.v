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

module TX_echo
(
	// input
	clk,			//??
	//reset,			//?
	tx_start,		// Inicio de la transmision
	tick,			// clock salida del br_gen
	data_in,		// resultado de la ALU que me lo pasa la interfaz

	// output
	tx_done_tick,	// fin de la transmision (se lo manda a la interfaz)
	tx_bit			// el dato que se transmite
);

parameter NBIT_DATA = `NBIT_DATA_LEN;	// largo del dato
parameter LEN_DATA = 3;//$clog2(NBIT_DATA); 
parameter NUM_TICKS = 16;
parameter LEN_NUM_TICKS = 4;//$clog2(NUM_TICKS); 

input clk;
//input reset;
input tx_start;
input tick;
input [NBIT_DATA-1:0] data_in;

output reg tx_done_tick=1'b0;
output tx_bit;

// Declaracion de estados
localparam [1:0] IDLE 	= 2'b 00;
localparam [1:0] START 	= 2'b 01;
localparam [1:0] DATA	= 2'b 10;
localparam [1:0] STOP 	= 2'b 11;

// declaracion de registros auxiliares
reg [1:0] state=IDLE;
reg [LEN_NUM_TICKS - 1:0] tick_counter=0;
reg [LEN_DATA - 1:0] num_bits=0;
reg [NBIT_DATA - 1:0] buffer=0;
reg tx_reg=1'b1;

//inicializacion
assign tx_bit = tx_reg;
//state = IDLE;
//tick_counter <= 0;
//num_bits <= 0;
//buffer <= 0;
//tx_done_tick <= 1'b0;
//tx_reg <= 1'b1; 
//~inicializacion

always @(posedge clk)
begin
	if(tick)
	begin
		case (state)
			IDLE:
				begin
					tx_reg = 1'b1; // avisa que esta en idle
					tx_done_tick=1'b0;
					if (tx_start) // cuando la interfaz me dice q empiece, empiezo
					begin
						state = START;
						tick_counter = 0;
						buffer = data_in;	//10101100
					end			 //10011010 	//00110101
				end				 //10101101
			START:
				begin
					tx_reg = 1'b0; // soy yo (Tx) quien tengo que avisar que empieza la trama
					if(tick_counter == NUM_TICKS-1) // ahora no me interesa posicionarme en el medio, sino que tengo que asegurarme que el bit va a estar en cero durante 16 ticks 
					begin
						state = DATA; // paso al estado DATA cuando termina el bit START
						tick_counter = 0;
						num_bits = 0;
					end
					else 
					begin
						tick_counter = tick_counter + 1;	
					end
				end
			DATA:
				begin
					tx_reg = buffer[0]; // empiezo a mandar el dato (escribiendolo en tx_reg, el cual esta cortocircuitado con tx_bit que es la salida al exterior)
					if(tick_counter == NUM_TICKS-1) // idem antes, espero 16 veces
					begin
						tick_counter = 0;
						buffer = buffer >> 1; // es para leer siempre desde la misma posicion
						if(num_bits == (NBIT_DATA - 1))
						begin
							state = STOP;
						end
						else 
						begin
							num_bits = num_bits + 1;	
						end
					end
					else 
					begin
						tick_counter = tick_counter + 1;	
					end
				end
			STOP:
				begin
					tx_reg = 1'b1; // el bit de stop esta definido como 1 (ademas, hay que dejarlo en 1 para que despues quede en IDLE y se detecte el START cuando se ponga en 0)
					if(tick_counter == (NUM_TICKS - 1))
					begin
						state = IDLE;
						tick_counter = 0;
						num_bits = 0;
						tx_done_tick = 1'b1;
					end
					else 
					begin
						tick_counter = tick_counter + 1;	
					end
				end

			default:
				begin
					state = IDLE; 
					tick_counter = 0; 
					num_bits = 0; 
					buffer = 0; // no sabemos si va en stop o no ???????????
					tx_reg = 1'b1;
					
				end
	endcase
	end
end
endmodule