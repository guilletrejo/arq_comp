`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: MEMORIA DE DATOS
//////////////////////////////////////////////////////////////////////////////////
module DATA_MEM
    #(
        parameter len_addr  = 11,
        parameter len_data  = 16,
	    parameter ram_depth = 2048 
    )
    (
        input clk,
        input Rd,                      // Enable para lectura (habilita registro de salida)
        input Wr,                      // Enable para escritura
        input [len_addr-1:0] Addr,     // Direccion del dato a leer/escribir
        input [len_data-1:0] In_Data,   // Dato a escribir si Wr = 1

        output [len_data-1:0] Out_Data // Contenido del dato leido si Rd = 1
    );

    /* Memoria Escritura/Lectura */
    reg [len_data-1:0] datos_ram [ram_depth-1:0]; // Vector de datos (primero tamaño de registro, segundo depth)
    reg [len_addr-1:0] Addr_reg;                  // Guarda el valor de la direccion
    
    assign Out_Data = datos_ram[Addr_reg];
    
    always @(posedge clk)   // Podria ser negedge??
    begin
      Addr_reg <= Addr;
      if(Wr == 1 && Rd == 0)
        begin
          datos_ram[Addr] <= In_Data;
        end
    end


endmodule
