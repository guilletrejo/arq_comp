`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name: PC
//////////////////////////////////////////////////////////////////////////////////
module PC
    #(
        parameter len_addr = 32  
    )
    (
        input clk,
        input reset,                        // Reinicia el PC a cero.
        input PCWrite,                      // Enable para copiar valor de la entrada del PC a la salida (viene de Hazard Detection Unit)
        input [len_addr-1:0] adder_input,   // Aumenta el valor del PC.
        //input start,                      //Flag que habilita el comienzo de ejecucion

        output reg [len_addr-1 : 0] pc_out = 0 // Direccion que se leera de INSTRUCTION_MEM
    );

    always @(posedge clk) // Podria hacer posedge aca?
    begin
        if(reset)
        begin
          pc_out = {len_addr{1'b 0}}; // = {vector de 32 ceros) 
        end
        else if(PCWrite)//&& start)
        begin
          pc_out = adder_input;
        end
        /*else
        begin
          pc_out = pc_out;
        end*/
    end    

endmodule
