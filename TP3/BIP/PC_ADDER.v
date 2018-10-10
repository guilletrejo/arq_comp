`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: PC ADDER
//////////////////////////////////////////////////////////////////////////////////
module PC_ADDER
    #(
        parameter len = 16,
        parameter sumando = 1 // Valor con el que se incrementa el PC 
                              // (es 1 porque el largo del registro es 16, igual al largo de la instruccion)
    )
    (
        input [len - 1 : 0] pc_actual, // salida del PC, instruccion que se leyo

        output reg [len - 1 : 0] adder_out
    );

    /*
        Cada vez que se incrementa la entrada (pc_actual), se la incrementa de nuevo.
        el incremento se habilita por: .el pc_adder, el enable, y el clock.
    */
    always@(*) 
    begin      
      adder_out = pc_actual + sumando;
    end

endmodule
