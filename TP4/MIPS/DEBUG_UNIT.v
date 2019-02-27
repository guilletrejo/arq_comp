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
    parameter cant_inst     = 64,       // cantidad esperada de instrucciones
    parameter NBIT_cant_inst = 6,
    parameter total_lenght   = 4        // queremos mandar solo el PC, por lo que con 4*8 nos alcanza. 
) 
( 
	input clk,								 // necesario para cambiar de estados
	input reset,
    input halt,								 // indica si cpu termino

    input [NBIT_DATA_LEN-1:0] test_reg,           // para probar si MIPS le manda a PC
    output reg [len_data-1:0] addr_mem_inst,     // direccion de la instruccion a escribir
    output reg [len_data-1:0] ins_to_mem,        // instruccion a escribir
    output reg wr_ram_inst,                      // pin para habilitar escritura a INST_MEM

    // UART
 	input rx_done_tick,  			  		 // fin de recepcion
	input tx_done_tick,						 // recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	 // Dato del RX recibido (si recibe un 1, significa CPU, START!)
	output reg tx_start,                 // LA INTERFAZ le tiene que avisar a TX cuando empezar
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
    reg [2:0] sub_state_next = SUB_INIT;
	// copian entradas
    reg reg_tx_done_tick;
	reg reg_rx_done_tick;
    // alimentan salidas
    reg [len_data-1:0] instruction;     // instruccion a escribir en memoria de programa
    reg write_enable_ram_inst;          // le dice al MIPS cuando escribir en mem la instruccion
	reg [len_data-1:0] num_inst;  // contador de instrucciones para direccionar donde escribir
	reg [NBIT_DATA_LEN-1:0] reg_data_out_next;
    
    /*assign addr_mem_inst = num_inst;
    assign ins_to_mem = instruction;
    assign wr_ram_inst = write_enable_ram_inst;*/

	/* Logica de actualizacion de registros
	   (pasa lo que hay en la entrada a los reg)
		en cada pulso de clock.
	*/
	always @(posedge clk)
	begin

		state <= state_next;
        sub_state <= sub_state_next;		
        reg_rx_done_tick <= rx_done_tick;
		reg_tx_done_tick <= tx_done_tick;

        ins_to_mem <= instruction;
        wr_ram_inst <= write_enable_ram_inst;
        addr_mem_inst <= num_inst;
        data_out <= reg_data_out_next;

		if(reset)
		begin
			state<=IDLE;
            sub_state<=SUB_INIT;
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
                        begin
                            state_next = PROGRAMMING;
                            sub_state_next = SUB_INIT;
                        end
                        else
                        begin
                            state_next = IDLE;
                            sub_state_next = SUB_INIT;
                        end
                    end
                    else
                    begin
                      state_next = IDLE;
                      sub_state_next = SUB_INIT;
                    end
				end

			PROGRAMMING:
				begin
                    case(sub_state)
                        SUB_INIT:
                            begin
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_1;
                            end
                        SUB_READ_1:
                            begin
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_2;
                            end
                        SUB_READ_2:
                            begin
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_3;
                            end
                        SUB_READ_4:
                            begin
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_WRITE_MEM;
                            end
                        SUB_WRITE_MEM:
                            begin
                              if(&instruction[31:26])
                              begin
                                state_next = WAITING;
                                sub_state_next = SUB_INIT;
                              end
                              else
                              begin
                                state_next = PROGRAMMING;
                                sub_state_next = SUB_READ_1;  
                              end
                            end
                        default:
                            begin
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_INIT;
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
                                  state_next = IDLE;
                                  sub_state_next = SUB_INIT;
                                end
                            ContinuousSignal:
                                begin
                                  state_next = CONTINUOUS;
                                  sub_state_next = SUB_INIT;
                                end
                            StepByStepSignal:
                                begin
                                  state_next = STEP_BY_STEP;
                                  sub_state_next = SUB_INIT;
                                end
                            default:
                                begin
                                  state_next = IDLE;
                                  sub_state_next = SUB_INIT;
                                end
                        endcase
					end
					else
					begin
						state_next = WAITING;
                        sub_state_next = SUB_INIT;
					end
				end
		
			STEP_BY_STEP:
				begin
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
                        if (rx_data_in == StepSignal)
                        begin
                          state_next = SENDING_DATA;
                          sub_state_next = SUB_INIT;
                        end
                        else
                        begin
                          state_next = STEP_BY_STEP;
                          sub_state_next = SUB_INIT;
                        end
					end
					else
					begin
						state_next = STEP_BY_STEP;
                        sub_state_next = SUB_INIT;
					end
				end
				
			CONTINUOUS:
				begin
					if (halt)
                    begin
                      state_next = SENDING_DATA;
                      sub_state_next = SUB_INIT;
                    end
                    else
                    begin
                      state_next = CONTINUOUS; 
                      sub_state_next = SUB_INIT;
                    end
				end
            SENDING_DATA:   
                begin
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
					begin
						state_next = IDLE;
                        sub_state_next = SUB_INIT;
					end
					else
					begin
						state_next = SENDING_DATA;
                        sub_state_next = SUB_INIT;
					end
				end
			default:
				begin
					state_next = IDLE;
                    sub_state_next = SUB_INIT;
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
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = wr_ram_inst;
				tx_start = 1'b0;
				reg_data_out_next  = data_out;
			end

			PROGRAMMING:
			begin
                case(sub_state)
                    SUB_INIT:
                        begin
                            instruction = ins_to_mem;
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = wr_ram_inst;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;
                        end
                    SUB_READ_1:
                        begin
                            instruction[31:8] = ins_to_mem[31:8];
                            instruction[7:0] = rx_data_in;
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = wr_ram_inst;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;    
                        end
                    SUB_READ_2:
                        begin
                            instruction[31:16] = ins_to_mem[31:16];
                            instruction[15:8] = rx_data_in;
                            instruction[7:0]  = ins_to_mem[7:0];
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = wr_ram_inst;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;   
                        end
                    SUB_READ_3:
                        begin
                            instruction[31:24] = ins_to_mem[31:24];
                            instruction[23:16] = rx_data_in;
                            instruction[15:0]  = ins_to_mem[15:0];
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = wr_ram_inst;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;   
                        end
                    SUB_READ_4:
                        begin
                            instruction[31:24] = rx_data_in;
                            instruction[23:0]  = ins_to_mem[23:0];
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = wr_ram_inst;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;   
                        end
                    SUB_WRITE_MEM:
                        begin
                            instruction = ins_to_mem;
                            num_inst = num_inst + 1;
                            write_enable_ram_inst = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;
                        end
                    default:
                    begin
                        instruction = ins_to_mem;
                        num_inst = addr_mem_inst;
                        write_enable_ram_inst = wr_ram_inst;
                        tx_start = 1'b0;
                        reg_data_out_next  = data_out;
                    end
                endcase
			end
			
			WAITING:
			begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;				
			end
			
			STEP_BY_STEP:
			begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;
			end
			
			CONTINUOUS:
			begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;
			end
			
            SENDING_DATA:
            begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                tx_start = 1'b1;
                reg_data_out_next = test_reg; // mandamos solo los primeros 8 bits del PC
            end

			default:
			begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;
			end
	
		endcase
	end
endmodule
