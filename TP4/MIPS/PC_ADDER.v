`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  ADD
//////////////////////////////////////////////////////////////////////////////////
module PC_ADDER
    #(
        parameter len_addr = 32
    )
    (
        input [len_addr-1 : 0] in_a,  // salida del PC
        input [len_addr-1 : 0] in_b,  // sumar 1 al PC (por que no 4? -> porque la memoria nos tira en su salida
                                      //                una palabra de 32 bits por cada aumento en 1 de la direccion)

        output reg [len_addr-1 : 0] adder_out
    );

    /*
        Cada vez que se incrementa la entrada (in_a), se la incrementa de nuevo.
        el incremento se habilita por: .el pc_adder, el enable, y el clock.
    */
    always@(*) 
    begin      
      adder_out = in_a + in_b;
    end

endmodule
