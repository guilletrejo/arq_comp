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
  parameter len_addr      = 7,
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
    output reg [len_addr-1:0] addr_mem_inst,     // direccion de la instruccion a escribir
    output reg [len_data-1:0] ins_to_mem,        // instruccion a escribir
    output reg wr_ram_inst,                      // pin para habilitar escritura a INST_MEM
    /*output rewr_flag,
    output [2:0] substate_flag,
    output [2:0] substatenext_flag,
    output [2:0] state_flag,
    output [2:0] statenext_flag,*/
    //output [len_data-1:0] test,

    output reg ctrl_clk_mips,
    output reg debug,                       // debug_flag para indicar si se esta escribiendo el programa en INST_MEM
    // UART
 	input rx_done_tick,  			  		 // fin de recepcion
	input tx_done_tick,						 // recibe la confirmacion desde UART que se termino de transimitir
 	input [NBIT_DATA_LEN-1:0] rx_data_in,  	 // Dato del RX recibido
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
	

    reg rewrite_flag=1'b0;
    reg rewrite_flag_prev=1'b0;
	// registros internos
	reg [2:0] state = IDLE;             //inicializado en IDLE
	reg [2:0] state_next = IDLE;
    reg [2:0] sub_state = SUB_INIT;
    reg [2:0] sub_state_next = SUB_INIT;
	// copian entradas
    reg reg_tx_done_tick=0;
	reg reg_rx_done_tick=0;
    // alimentan salidas
    reg [len_data-1:0] instruction=0;     // instruccion a escribir en memoria de programa
    reg write_enable_ram_inst=1'b0;          // le dice al MIPS cuando escribir en mem la instruccion
	reg [len_addr-1:0] num_inst=8'b0;  // contador de instrucciones para direccionar donde escribir
	reg [NBIT_DATA_LEN-1:0] reg_data_out_next=0;
  reg [NBIT_DATA_LEN-1:0] reg_rxdatain=0;  


    //assign test = reg_rxdatain;
    //assign test = 32'b11111111111111111111111111111111;



    /*assign rewr_flag = rewrite_flag;
    assign substate_flag = sub_state;
    assign substatenext_flag = sub_state_next;
    assign state_flag = state;
    assign statenext_flag = state_next;*/

    //assign addr_mem_inst = num_inst;
    //assign ins_to_mem = instruction;
    /*assign wr_ram_inst = write_enable_ram_inst;*/
    /*generate
	 initial
    begin
        addr_mem_inst = 0;
        
    end
	 endgenerate*/


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
    //test <= reg_rxdatain;

    ins_to_mem <= instruction;
    wr_ram_inst <= write_enable_ram_inst;
    addr_mem_inst <= num_inst;
    data_out <= reg_data_out_next;
    rewrite_flag_prev <= rewrite_flag;

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
          ctrl_clk_mips = 1'b0;
          rewrite_flag = rewrite_flag_prev;
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0)) 
					begin
                if (reg_rxdatain == StartSignal) 
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
        ctrl_clk_mips = 1'b0;
                    case(sub_state)
                        SUB_INIT:
                        begin
                            if ((rx_done_tick == 0) && (reg_rx_done_tick == 0)) // no hubo ningun cambio en rx_done
                            begin
                              rewrite_flag = 1'b0;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_1;
                            end
                            else
                            begin
                              rewrite_flag = 1'b1;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_INIT;
                            end
                        end
                        SUB_READ_1:
                        begin
                            if((rx_done_tick == 1) && (reg_rx_done_tick == 0)) // subio rx donetick
                            begin
                              rewrite_flag = 1'b0;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_2;
                            end
                            else if ((rx_done_tick == 0) && (reg_rx_done_tick == 1)) // bajo rx donetick
                            begin
                              rewrite_flag = 1'b1;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_1;
                            end
                            else
                            begin
                              rewrite_flag = 1'b1;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_1;
                            end
                        end
                        SUB_READ_2:
                        begin
                            if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
                            begin
                              rewrite_flag = 1'b0;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_3;
                            end
                            else if ((rx_done_tick == 0) && (reg_rx_done_tick == 1))
                            begin
                              rewrite_flag = 1'b1;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_2;
                            end
                            else
                            begin
                              rewrite_flag = rewrite_flag_prev;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_2;
                            end
                        end
                        SUB_READ_3:
                        begin
                            if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
                            begin
                              rewrite_flag = 1'b0;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_4;
                            end
                            else if ((rx_done_tick == 0) && (reg_rx_done_tick == 1))
                            begin
                              rewrite_flag = 1'b1;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_3;
                            end
                            else
                            begin
                              rewrite_flag = rewrite_flag_prev;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_3;
                            end
                        end
                        SUB_READ_4:
                        begin
                            if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
                            begin
                              rewrite_flag = 1'b0;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_WRITE_MEM;
                            end
                            else if ((rx_done_tick == 0) && (reg_rx_done_tick == 1))
                            begin
                              rewrite_flag = 1'b1;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_4;
                            end
                            else
                            begin
                              rewrite_flag = rewrite_flag_prev;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_READ_4;
                            end
                        end
                        SUB_WRITE_MEM:
                            begin
                              rewrite_flag = rewrite_flag_prev;
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
                              rewrite_flag = rewrite_flag_prev;
                              state_next = PROGRAMMING;
                              sub_state_next = SUB_INIT;
                            end
                    endcase
				end
		
			WAITING:
				begin
          ctrl_clk_mips = 1'b0;
          rewrite_flag = rewrite_flag_prev;
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
						case(reg_rxdatain)
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
          ctrl_clk_mips = 1'b0;
          rewrite_flag = rewrite_flag_prev;
					if((rx_done_tick == 1) && (reg_rx_done_tick == 0))
					begin
            if (reg_rxdatain == StepSignal)
            begin
              ctrl_clk_mips = 1'b1;
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
          ctrl_clk_mips = 1'b1;
                    rewrite_flag = rewrite_flag_prev;
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
          ctrl_clk_mips = 1'b0;
          rewrite_flag = rewrite_flag_prev;
					if((tx_done_tick == 1) && (reg_tx_done_tick == 0))
            begin
              if(halt)
                begin
                  state_next = WAITING;
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
              state_next = SENDING_DATA;
              sub_state_next = SUB_INIT;
            end
				end
			default:
				begin
          ctrl_clk_mips = 1'b0;
          rewrite_flag = rewrite_flag_prev;
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
        num_inst = 8'b0;
        write_enable_ram_inst = 1'b0;
        //ctrl_clk_mips = 1'b0;
        debug = 1'b0;
				tx_start = 1'b0;
				reg_data_out_next  = data_out;
        reg_rxdatain = rx_data_in;
			end

			PROGRAMMING:
			begin
                case(sub_state)
                    SUB_INIT:
                        begin
                            instruction = 0;
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = 1'b0;
                           // ctrl_clk_mips = 1'b0;
                            debug = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;
                            reg_rxdatain = rx_data_in;
                        end
                    SUB_READ_1: //CONTROLZETEAME HASTA QUE YO DESAPAREZCA
                        begin
                            num_inst = addr_mem_inst;
                            reg_rxdatain = rx_data_in;
                            write_enable_ram_inst = 1'b0;
                            //ctrl_clk_mips = 1'b0;
                            debug = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;
                            if(!rewrite_flag)
                            begin
                              instruction = {{24{1'b0}},reg_rxdatain};
                            end
                            else
                            begin
                              instruction = ins_to_mem;
                            end
                            /*else
                            begin
                              instruction = ins_to_mem;
                              num_inst = addr_mem_inst;
                              write_enable_ram_inst = 1'b0;
                              ctrl_clk_mips = 1'b0;
                              debug = 1'b0;
                              tx_start = 1'b0;
                              reg_data_out_next  = data_out;
                            end*/
                        end
                    SUB_READ_2:
                        begin
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = 1'b0;
                            reg_rxdatain = rx_data_in;
                           // ctrl_clk_mips = 1'b0;
                            debug = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;  
                            if(!rewrite_flag)
                            begin
                              instruction = {{16{1'b0}},reg_rxdatain,ins_to_mem[7:0]};                               
                            end
                            else
                            begin
                              instruction = ins_to_mem;
                            end
                            /*else
                            begin
                              instruction = ins_to_mem;
                              num_inst = addr_mem_inst;
                              write_enable_ram_inst = 1'b0;
                              ctrl_clk_mips = 1'b0;
                              debug = 1'b0;
                              tx_start = 1'b0;
                              reg_data_out_next  = data_out;
                            end */
                        end
                    SUB_READ_3:
                        begin
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = 1'b0;
                            reg_rxdatain = rx_data_in;
                            //ctrl_clk_mips = 1'b0;
                            debug = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out; 
                            if(!rewrite_flag)
                            begin
                              instruction = {{8{1'b0}},reg_rxdatain,ins_to_mem[15:0]};                                                            
                            end
                            else
                            begin
                              instruction = ins_to_mem;
                            end
                            /*else
                            begin
                              instruction = ins_to_mem;
                              num_inst = addr_mem_inst;
                              write_enable_ram_inst = 1'b0;
                              ctrl_clk_mips = 1'b0;
                              debug = 1'b0;
                              tx_start = 1'b0;
                              reg_data_out_next  = data_out;
                            end  */
                        end
                    SUB_READ_4:
                        begin
                            num_inst = addr_mem_inst;
                            write_enable_ram_inst = 1'b0;
                            reg_rxdatain = rx_data_in;
                           // ctrl_clk_mips = 1'b0;
                            debug = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;   
                            if(!rewrite_flag)
                            begin
                                instruction = {reg_rxdatain,ins_to_mem[23:0]};
                            end
                            else
                            begin
                              instruction = ins_to_mem;
                            end
                            /*else
                            begin
                              instruction = ins_to_mem;
                              num_inst = addr_mem_inst;
                              write_enable_ram_inst = 1'b0;
                              ctrl_clk_mips = 1'b0;
                              debug = 1'b0;
                              tx_start = 1'b0;
                              reg_data_out_next  = data_out;
                            end*/
                        end
                    SUB_WRITE_MEM:
                        begin
                            instruction = ins_to_mem;
                            num_inst = addr_mem_inst + 8'b1;
                            reg_rxdatain = rx_data_in;
                            write_enable_ram_inst = 1'b1;
                           // ctrl_clk_mips = 1'b0;
                            debug = 1'b1;
                            tx_start = 1'b0;
                            reg_data_out_next  = data_out;
                        end
                        
                    default:
                    begin
                        instruction = ins_to_mem;
                        num_inst = addr_mem_inst;
                        reg_rxdatain = rx_data_in;
                        write_enable_ram_inst = 1'b0;
                        //ctrl_clk_mips = 1'b0;
                        debug = 1'b0;
                        tx_start = 1'b0;
                        reg_data_out_next  = data_out;
                    end
                endcase
			end
			
			WAITING:
			begin
                instruction = ins_to_mem;
                reg_rxdatain = rx_data_in;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
               // ctrl_clk_mips = 1'b0;
                debug = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;				
			end
			
			STEP_BY_STEP:
			begin
                instruction = ins_to_mem;
                reg_rxdatain = rx_data_in;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                //ctrl_clk_mips = 1'b0;
                debug = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;
			end
			
			CONTINUOUS:
			begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                reg_rxdatain = rx_data_in;
                write_enable_ram_inst = 1'b0;
               // ctrl_clk_mips = 1'b1;
                debug = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;
			end
			
      SENDING_DATA:
      begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                reg_rxdatain = rx_data_in;
                write_enable_ram_inst = 1'b0;
                //ctrl_clk_mips = 1'b0;
                debug = 1'b0;
                tx_start = 1'b1;
                reg_data_out_next = test_reg; // mandamos solo los primeros 8 bits del PC
      end

			default:
			begin
                instruction = ins_to_mem;
                num_inst = addr_mem_inst;
                write_enable_ram_inst = 1'b0;
                reg_rxdatain = rx_data_in;
               // ctrl_clk_mips = 1'b0;
                debug = 1'b0;
                tx_start = 1'b0;
                reg_data_out_next  = data_out;
			end
	
		endcase
	end
endmodule
