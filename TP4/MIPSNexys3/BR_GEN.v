`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: BR_GEN
//////////////////////////////////////////////////////////////////////////////////

module BR_GEN(
	input CLK,  		//clock de la FPGA
	
	output reg TICK = 0 //clock del RX
);
	 
parameter BAUD_RATE = 9600;
parameter CLK_RATE = 100000000; //valor del clock de la placa
localparam NUM_TICKS = 16;		 //division del baudio

parameter TICK_RATE = CLK_RATE / (BAUD_RATE * NUM_TICKS);	//frecuencia del clk del RX

/* calcula el largo (en bits) necesario del
   registro que almacenara el contador usado
   para generar el tick rate (163 en el ej. de la filmina)
   para contar hasta el TICK_RATE		
*/
parameter LEN_REG_ACUM = 10; 	//clog2(TICK_RATE);

// registro para ir sumando el tick rate
reg [LEN_REG_ACUM - 1 : 0] acumulator = 0;												


always @(posedge CLK) 
begin			
	acumulator = acumulator + 10'b1;
	if (acumulator == (TICK_RATE)) 
		begin
			TICK = 1;
			acumulator = 0;
		end
	else
		TICK = 0;
end

endmodule
