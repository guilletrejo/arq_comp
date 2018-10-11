`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: MEMORIA DE PROGRAMA
//////////////////////////////////////////////////////////////////////////////////
module PROGRAM_MEM
    #(
        parameter len_addr = 11,
        parameter len_data = 16,
		  parameter ram_depth= 2048,
        parameter init_file = ""    //se le va a pasar el path 
    )
    (
        input clk,
        input [len_addr-1:0]Addr,     //direccion de la instruccion

        output [len_data-1:0]Data     //contenido de la instruccion
    );
    //memoria de solo lectura
    reg [len_data-1:0] instruccion_ram [ram_depth-1:0]; //vector de instrucciones(primero tamaño de registro, segundo depth)
    reg [len_addr-1:0] Addr_reg;                  //contiene el valor de la direccion accedida
    
    assign Data = instruccion_ram[Addr_reg];
	 
	 initial
	 begin
		$readmemh(init_file,instruccion_ram);
	 end

    always @(posedge clk)   // Podria ser negedge??
    begin
      Addr_reg <= Addr;   
    end
endmodule
