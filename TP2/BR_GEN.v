`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:52 09/06/2018 
// Design Name: 
// Module Name:    BR_GEN 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BR_GEN(
	input CLK,  //clock de la FPGA
	input reset,//ver para que???????????
	output reg TICK //clock del RX
    );
	 
parameter BAUD_RATE = 9600;
parameter CLK_RATE = 40000000; //valor del clock de la placa
localparam NUM_TICKS = 16; //division del baudio

parameter TICK_RATE = CLK_RATE / (BAUD_RATE * NUM_TICKS);//frecuencia del clk del RX
parameter LEN_REG_ACUM = $clog2(TICK_RATE); // calcula el largo (en bits) necesario del
													     // registro que almacenara el contador usado
												        // para generar el tick rate (163 en el ej. de la filmina)
reg [LEN_REG_ACUM - 1 : 0] acumulador = 0;  // para contar hasta el TICK_RATE													

always @(posedge CLK) 
begin
	if (reset)
		begin
			acumulator = 0;
			TICK = 0;
		end
	else
		begin			
			acumulator = acumulator + 1;
			
			if (acumulator == (TICK_RATE)) 
				begin
					TICK = 1;
					acumulator = 0;
				end
			else
			   TICK = 0;
		end
end

endmodule
