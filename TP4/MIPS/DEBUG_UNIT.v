`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//					 Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name:  UNIDAD DE DEBUG
//////////////////////////////////////////////////////////////////////////////////

module DEBUG_UNIT
#(
	parameter NBIT_DATA_LEN = 8, 		// buffer bits 
	parameter len_data		= 32,	    // bits del acumulador
    parameter cant_inst     = 64,        // cantidad esperada de instrucciones
    parameter NBIT_cant_inst = 6
) 
( 
	input clk,								 // necesario para cambiar de estados
	input reset,
    input halt,								 // indica si cpu termino

    input [len_data-1:0] test_reg,           // para probar si MIPS le manda a PC
    output [len_data-1:0] addr_mem_inst,     // direccion de la instruccion a escribir
    output [len_data-1:0] ins_to_mem,        // instruccion a escribir
    output wr_ram_inst,                      // pin para habilitar escritura a INST_MEM

    // UART
 	input rx_done_tick,  			  		 // fin de recepcion
	input tx_done_tick,						 // recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	 // Dato del RX recibido (si recibe un 1, significa CPU, START!)
	output reg tx_start = 0,                 // LA INTERFAZ le tiene que avisar a TX cuando empezar
 	output reg [NBIT_DATA_LEN-1:0] data_out  // para escribir en TX (para mandar las cosas del MIPS a la compu, por ejemplo el PC)
); 

	// estados 
	localparam [2:0] IDLE           = 3'b 000,
                     PROGRAMMING    = 3'b 001,
                     WAITING        = 3'b 010,
                     STEP_BY_STEP   = 3'b 011,
                     SENDING_DATA   = 3'b 100,
                     CONTINUOUS     = 3'b 101;

    localparam [2:0] SUB_INIT       = 3'b 000,
                     SUB_READ_1     = 3'b 001,
                     SUB_READ_2     = 3'b 010,
                     SUB_READ_3     = 3'b 011,
                     SUB_READ_4     = 3'b 100,
                     SUB_WRITE_MEM  = 3'b 101;

    /*
        Señales de comparacion con los datos que llegan desde la PC
    */
    localparam [7:0] StartSignal        = 8'b 00000001,
                     ContinuousSignal   = 8'b 00000010,
                     StepByStepSignal   = 8'b 00000011,
                     ReProgramSignal    = 8'b 00000101,
                     StepSignal         = 8'b 00000110;
	
	// registros internos
	reg [2:0] state = IDLE;             //inicializado en IDLE
	reg [2:0] state_next = IDLE;
    reg [2:0] sub_state = SUB_INIT;
	reg reg_tx_done_tick;
	reg reg_rx_done_tick;
    reg [len_data-1:0] instruction;     // instruccion a escribir en memoria de programa
    reg write_enable_ram_inst;          // le dice al MIPS cuando escribir en mem la instruccion
	reg [NBIT_cant_inst-1:0] num_inst;  // contador de instrucciones para direccionar donde escribir
	//reg reg_cpu_start_next;
	//reg reg_cpu_reset_next;
	reg [NBIT_DATA_LEN-1:0] reg_data_out_next;



    assign ins_to_mem = instruction;
    assign addr_mem_inst = num_inst;
    assign wr_ram_inst = write_enable_ram_inst;
	
	/* Logica de actualizacion de registros
	   (pasa lo que hay en la entrada a los reg)
		en cada pulso de clock.
	*/
	always @(posedge clk)
	begin
		reg_rx_done_tick <= rx_done_tick;
		reg_tx_done_tick <= tx_done_tick;
        data_out  <= reg_data_out_next;
		state <= state_next;
		
		//cpu_start <= reg_cpu_start_next;
		//cpu_reset <= reg_cpu_reset_next;
		if(reset)
		begin
			state<=IDLE;
		end
	end
	
	/* Logica de actualizacion de estados.
		Actualiza si detecta un flanco ascendente en rx_done para el caso RECEIVE
		o en tx_done en el caso de SEND_ACC1, SEND_ACC2 y SEND_CLK
	*/
	always @(*)
	begin
		
		case(state)
			IDLE:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0)) 
					begin
                    if (rx_data_in == StartSignal) 
						state_next = PROGRAMMING;
                        sub_state = SUB_INIT;
					end
					else
					begin
						state_next = IDLE;
					end
				end

			PROGRAMMING:
				begin
                    case(sub_state)
                        SUB_INIT:
                            begin
                              sub_state = SUB_READ_1;
                            end
                        SUB_READ_1:
                            begin
                              sub_state = SUB_READ_2;
                            end
                        SUB_READ_2:
                            begin
                              sub_state = SUB_READ_3;
                            end
                        SUB_READ_4:
                            begin
                              sub_state = SUB_WRITE_MEM;
                            end
                        SUB_WRITE_MEM:
                            begin
                              if(&instruction[31:26])
                              begin
                                state = WAITING;
                                sub_state = SUB_INIT;
                              end
                              else
                              begin
                                sub_state = SUB_READ_1;  
                              end
                            end
                    endcase
				end
		
			WAITING:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						case(rx_data_in)
                            ReProgramSignal:
                                begin
                                  state = IDLE;
                                end
                            ContinuousSignal:
                                begin
                                  state = CONTINUOUS;
                                end
                            StepByStepSignal:
                                begin
                                  state = STEP_BY_STEP;
                                end
                        endcase
					end
					else
					begin
						state_next = WAITING;
					end
				end
		
			STEP_BY_STEP:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
                        if (rx_data_in == StepSignal)
                        begin
                          state = SENDING_DATA;
                        end
					end
					else
					begin
						state_next = STEP_BY_STEP;
					end
				end
				
			CONTINUOUS:
				begin
					if (halt)
                    begin
                      state = SENDING_DATA;
                    end
                    else
                    begin
                      state = CONTINUOUS;   // ver esto, para que usan el registro ciclos?
                    end
				end
            SENDING_DATA:   
                begin
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = IDLE;
					end
					else
					begin
						state_next = SENDING_DATA;
					end
				end
			default:
				begin
					state_next = IDLE;
				end
		endcase
	end
	
	/* Logica de recepcion de datos de RX.
	   (inicio para CPU), y de envio de datos a TX.
	*/
	always @(*)
	begin

		case(state)
			
			IDLE:
			begin
				tx_start = 1'b0;
				reg_data_out_next  = data_out;
				//reg_cpu_reset_next = reg_cpu_reset_next[1]; // recibo cpu_reset
			end

			PROGRAMMING:
			begin
                case(sub_state)
                    SUB_INIT:
                        begin
                            tx_start = 1'b0;
                            num_inst = 0;
                            reg_data_out_next = data_out;
                            write_enable_ram_inst = 1'b0;
                        end
                    SUB_READ_1:
                        begin
                            tx_start = 1'b0;
                            reg_data_out_next = data_out;
                            write_enable_ram_inst = 1'b0;
                            instruction[7:0] = rx_data_in;   
                        end
                    SUB_READ_2:
                        begin
                            tx_start = 1'b0;
                            reg_data_out_next = data_out;
                            write_enable_ram_inst = 1'b0;
                            instruction[15:8] = rx_data_in;
                        end
                    SUB_READ_3:
                        begin
                            tx_start = 1'b0;
                            reg_data_out_next = data_out;
                            write_enable_ram_inst = 1'b0;
                            instruction[23:16] = rx_data_in;
                        end
                    SUB_READ_4:
                        begin
                            tx_start = 1'b0;
                            reg_data_out_next = data_out;
                            write_enable_ram_inst = 1'b0;
                            instruction[31:24] = rx_data_in;
                        end
                    SUB_WRITE_MEM:
                        begin
                            tx_start = 1'b0;
                            reg_data_out_next = data_out;
                            num_inst = num_inst + 1;
                            write_enable_ram_inst = 1'b1;
                        end
                endcase
			end
			
			WAITING:
			begin
				tx_start = 1'b0;
                reg_data_out_next = data_out;
                write_enable_ram_inst = 1'b0;
                // if (ReProgramSignal) reprogram = 1; ??????????				
			end
			
			STEP_BY_STEP:
			begin
				tx_start = 1'b0;
                reg_data_out_next = data_out;
                // ?????? what to do hir
			end
			
			CONTINUOUS:
			begin
				tx_start = 1'b0;
				reg_data_out_next = data_out;
                // ?? 
			end
			
            SENDING_DATA:
            begin
                tx_start = 1'b1;
                //reg_data_out_next = program counter o algo;
            end

			default:
			begin
				tx_start = 1'b0;			
				reg_data_out_next = data_out;
			end
	
		endcase
	end
endmodule
