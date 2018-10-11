`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//				 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2018
// Module Name: INSTRUCTION DECODER
//////////////////////////////////////////////////////////////////////////////////
`define len_opcode 3
module INSTRUCTION_DECODER
    #
    (
        parameter len_opcode = `len_opcode,               // el ISA del BIP1 solo tiene 8 instrucciones
        parameter len_mux_a  = 2
    )
    (
        input [len_opcode - 1 : 0] Opcode,      

        output reg WrPC,                        // para indicarle al PC que incremente
        output reg [len_mux_a - 1 : 0] SelA,    // sel para el mux que da la entrada al acumulador
        output reg SelB,                        // idem para la entrada 2 de la ALU
        output reg WrAcc,                       // enable para el acumulador (le dice que pase su entrada a la ALU)
        output reg Op,                          // operador, para que la ALU sepa si es suma o resta
        /* Bits que indican a DATA_MEM si tiene que o escribir o leer
           el dato que esta en su entrada In_Data en la correspondiente direccion
           que esta en su entrada Addr. */
        output reg WrRam,
        output reg RdRam
    );

    always @(*) // no tiene clock, es un combinacional
    begin
        case (Opcode)
          `len_opcode'b 000: // Halt
            begin
                WrPC <= 0;  // Le dice al PC que deje de contar
                SelA <= 0; 
                SelB <= 0;
                WrAcc <= 0;
                Op <= 0;
                WrRam <= 0;
                RdRam <= 0;
            end
          `len_opcode'b 001: // Store Variable (DM[operand] ← ACC)
            begin
                WrPC <= 1;
                SelA <= 0;  // No le importa cual es SelA porque el valor ya esta en ACC
                SelB <= 0;  // Idem anterior
                WrAcc <= 0; // No se escribe en ACC porque se pisaria el valor a guardar en DATA_MEM
                Op <= 0;    // No importa porque no opero
                WrRam <= 1; // Quiero escribir un valor en DATA_MEM
                RdRam <= 0;
            end
          `len_opcode'b 010: // Load Variable (ACC ← DM[operand])
            begin
                WrPC <= 1;
                SelA <= 0;  // Va a poner la salida de DATA_MEM en el ACC
                SelB <= 0;  // No importa porque no se opera
                WrAcc <= 1; // Se escribe en ACC el valor de DATA_MEM
                Op <= 0;    // No importa porque no opero
                WrRam <= 0; 
                RdRam <= 1; // Quiero sacar (leer) un valor de DATA_MEM
            end
          `len_opcode'b 011: // Load Immediate (ACC ← operand)
            begin
                WrPC <= 1;
                SelA <= 1;  // Va a poner el valor del operando (ya extendido) en el ACC
                SelB <= 0;  // No importa porque no se opera
                WrAcc <= 1; // Se escribe en ACC el valor del operando
                Op <= 0;    // No importa porque no opero
                WrRam <= 0; // No accedo a memoria 
                RdRam <= 0;
            end
          `len_opcode'b 100: // Add Variable (ACC ← ACC + DM[operand])
            begin
                WrPC <= 1;
                SelA <= 2;  // Ya hay algo en ACC, entonces sumo con lo que venga de DATA_MEM y lo guardo en ACC
                SelB <= 0;  // Selecciona lo que viene de DATA_MEM
                WrAcc <= 1; // Se escribe en ACC el resultado de la suma
                Op <= 0;    // Op = 0 -> Suma
                WrRam <= 0; 
                RdRam <= 1; // Leo de memoria el segundo sumando
            end
          `len_opcode'b 101: // Add Immediate (ACC ← ACC + operand)
            begin
                WrPC <= 1;
                SelA <= 2;  // Ya hay algo en ACC, entonces sumo con el operando y lo guardo en ACC
                SelB <= 1;  // Selecciona el valor inmediato del operando
                WrAcc <= 1; // Se escribe en ACC el resultado de la suma
                Op <= 0;    // Op = 0 -> Suma
                WrRam <= 0; // No accedo a memoria
                RdRam <= 0; 
            end
          `len_opcode'b 110: // Substract Variable (ACC ← ACC - DM[operand])
            begin
                WrPC <= 1;
                SelA <= 2;  // Ya hay algo en ACC, entonces le resto lo que venga de DATA_MEM y lo guardo en ACC
                SelB <= 0;  // Selecciona lo que viene de DATA_MEM
                WrAcc <= 1; // Se escribe en ACC el resultado de la resta
                Op <= 1;    // Op = 1 -> Resta
                WrRam <= 0; 
                RdRam <= 1; // Leo de memoria el sustraendo
            end
          `len_opcode'b 111: // Substract Immediate (ACC ← ACC - operand)
            begin
                WrPC <= 1;
                SelA <= 2;  // Ya hay algo en ACC, entonces le resto el operando y lo guardo en ACC
                SelB <= 1;  // Selecciona el valor inmediato del operando
                WrAcc <= 1; // Se escribe en ACC el resultado de la resta
                Op <= 1;    // Op = 1 -> Resta
                WrRam <= 0; // No accedo a memoria
                RdRam <= 0; 
            end 
        endcase
    end


endmodule
