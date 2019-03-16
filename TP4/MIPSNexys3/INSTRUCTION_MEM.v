`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name: MEMORIA DE PROGRAMA
//////////////////////////////////////////////////////////////////////////////////

module INSTRUCTION_MEM
    #(
        parameter len_addr  = 7,
        parameter len_data  = 32,
		parameter ram_depth = 128, // Cantidad de entradas de la memoria
        parameter init_file = "test2.hex"    // Se le va a pasar el path text.hex es para esto
    )
    (
       // input clk,
        //input reset,
        //input flush,
        //input ena,
        input Wr,                      // enable para escritura
        input [len_addr-1:0] Addr,     // Direccion de la instruccion a leer o escribir
        input [len_data-1:0] In_Data,  // Instruccion a escribir

        output [len_data-1:0] Data,     // Contenido de la instruccion leida
        //TEST
        //output [len_data-1:0] Data_test, //TEEEEST
        //
        output wire_douta               // Para detectar instruccion de HALT
    );

    /* Memoria de lectura y escritura */
    reg [len_data-1:0] instruccion_ram [ram_depth-1:0]; // Vector de instrucciones (primero tamaño de registro, segundo depth)
    //reg [len_data-1:0] ram_data = {len_data{1'b0}};
    reg [len_addr-1:0] Addr_reg;                        // Guarda el valor de la direccion accedida
    
    assign Data = instruccion_ram[Addr_reg];
    assign wire_douta = &instruccion_ram[Addr_reg][len_data-1:len_data-6]; // verifica si el Opcode es 111111 para hacer el halt
    
    //test
   // assign Data_test = instruccion_ram[1];
	 
	 /*  Para inicializar la RAM en 0000 0000 */
     initial
	 begin
		$readmemh(init_file,instruccion_ram);
	 end

    always @(posedge Wr) 
    begin
		instruccion_ram[Addr] <= In_Data;
	end

    always @(Addr)
    begin
        Addr_reg <= Addr;
    end
    
endmodule
 