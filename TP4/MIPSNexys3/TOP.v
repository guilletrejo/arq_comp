`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Alumnos:
//			     Ortmann, Nestor Javier
// 				 Trejo, Bruno Guillermo
// Year: 		 2019
// Module Name: TOP DI TUTTI TOPI
//////////////////////////////////////////////////////////////////////////////////
module TOP
#(
    parameter NBIT_DATA_LEN = 8,
	parameter len_data = 32,
	parameter cant_registros = 9,
	parameter len_bucket = cant_registros*len_data,
	parameter len_addr = 7,
	parameter num_bits = 5,
	parameter len_exec_bus = 11,
	parameter len_mem_bus = 9,
	parameter len_wb_bus = 2
)
(
    input CLK100MHZ,
    input SWITCH_RESET,
    input RX_INPUT,

    output TX_OUTPUT,            
    // output led_fpga... para probar algo
	output [NBIT_DATA_LEN-1:0] led_fpga
);

	//wire [32-1:0] conn_led;

    wire clk_mips, 
         ctrl_clk_mips; 
		 //clk, 
         //reset, 
         //reset_mips;
             
	//assign clk = CLK100MHZ;
    //assign reset = SWITCH_RESET; 
    
    wire connect_uart_rx_done,
	     connect_uart_tx_start,
	     connect_uart_tx_done,
		 //connect_restart_recolector,
		 //connect_send_regs,
		 //connect_enable_next,
		 //connect_reprogram,
		 connect_debug_mode,
		 connect_halt,
		 connect_tx_debug,
		 //connect_rx_debug,
		 connect_wea_ram_inst;
	//wire [NBIT_DATA_LEN-1:0]	connect_pc_debug;
		 
	wire [len_addr-1:0] connect_addr_mem_inst;
	wire [len_data-1:0] connect_ins_to_mem;

	/*wire [(nb_Latches_1_2*8)-1:0] connect_Latches_1_2;
	wire [(nb_Latches_2_3*8)-1:0] connect_Latches_2_3;
	wire [(nb_Latches_3_4*8)-1:0] connect_Latches_3_4;
	wire [(nb_Latches_4_5*8)-1:0] connect_Latches_4_5;*/


    wire [NBIT_DATA_LEN-1:0] connect_uart_data_in,
			                 connect_uart_data_out;

	//assign connect_write_dataconnect_write_data_5_2_5_2 = (connect_out_writeBack_bus[0]) ? connect_read_data : connect_out_addr_mem;

	assign clk_mips = (ctrl_clk_mips) ? (CLK100MHZ) : (1'b 0);

	//assign connect_rx_debug = RX_INPUT; //(1 & estamos_en_test_bench) ? connect_tx_debug : UART_TXD_IN;
	assign TX_OUTPUT = connect_tx_debug;
	//assign led_fpga = connect_pc_debug;
	//assign tx_done_debug = connect_uart_tx_done;

	wire [len_bucket-1:0] bucket;

	/*assign led[0] = connect_uart_tx_start;	
	assign led[1] = connect_halt;
	assign led[2] = reset;*/

	/*wire [5:0] connect_state_out;

	assign led_state = connect_state_out;*/

	TOP_MIPS #(
	.len_data(len_data),
	.num_bits(num_bits),
	.len_exec_bus(len_exec_bus),
	.len_mem_bus(len_mem_bus),
	.len_wb_bus(len_wb_bus)
	/*.nb_Latches_1_2(nb_Latches_1_2),
	.nb_Latches_2_3(nb_Latches_2_3),
	.nb_Latches_3_4(nb_Latches_3_4),
	.nb_Latches_4_5(nb_Latches_4_5)*/
	)
	u_top_mips(
		.clk(clk_mips),
		.reset(SWITCH_RESET),// | reset_mips),

		//para debug
		.debug_flag(connect_debug_mode),
		//.in_addr_debug(connect_addr_recolector_mips),
		.in_addr_mem_inst(connect_addr_mem_inst),
		.in_ins_to_mem(connect_ins_to_mem),
		.wea_ram_inst(connect_wea_ram_inst),

		//.out_reg1_recolector(conn_led),
		//.out_mem_wire(conn_led),
		
		.out_reg0_recolector(bucket[31:0]),
		.out_reg1_recolector(bucket[63:32]),
		.out_reg2_recolector(bucket[95:64]),
		.out_reg3_recolector(bucket[127:96]),
		.out_reg4_recolector(bucket[159:128]),
		.out_reg5_recolector(bucket[191:160]),
		.out_reg6_recolector(bucket[223:192]),
		.out_reg7_recolector(bucket[255:224]),

		.out_inst_test(led_fpga),
		.out_pc(bucket[287:256]),

		.halt_flag(connect_halt)
		/*.Latches_1_2(connect_Latches_1_2),
		.Latches_2_3(connect_Latches_2_3),
		.Latches_3_4(connect_Latches_3_4),
		.Latches_4_5(connect_Latches_4_5)*/
		);

	DEBUG_UNIT #(
		.NBIT_DATA_LEN(NBIT_DATA_LEN),
        .len_data(len_data),
		.len_contador(clogb2(len_bucket/8)),
		.len_bucket(len_bucket)
		)
		u_debug_unit(
		    .clk(CLK100MHZ),
		    .reset(SWITCH_RESET),
		    .halt(connect_halt),
		    .bucket(bucket),
		    /*.Latches_1_2(connect_Latches_1_2),
		    .Latches_2_3(connect_Latches_2_3),
		    .Latches_3_4(connect_Latches_3_4),
		    .Latches_4_5(connect_Latches_4_5),
		    .recolector(connect_data_recolector),*/

		    // outputs
		    //.state_out             (connect_state_out),
		    .addr_mem_inst(connect_addr_mem_inst),
		    .ins_to_mem(connect_ins_to_mem),
		    //.reset_mips(reset_mips),
		    //.reprogram(connect_reprogram),
		    .ctrl_clk_mips(ctrl_clk_mips), // para parar el mips cuando esta grabando el programa/enviando resultados
			//.restart_recolector(connect_restart_recolector),
			//.send_regs_recolector(connect_send_regs),
			//.enable_next_recolector(connect_enable_next),
			.debug(connect_debug_mode),
			.wr_ram_inst(connect_wea_ram_inst),
		
			//.test(conn_led),

		    //UART
		    .rx_done_tick(connect_uart_rx_done),	    
		    .tx_done_tick(connect_uart_tx_done),
		    .rx_data_in(connect_uart_data_out), 
		    .tx_start(connect_uart_tx_start),
		    .data_out(connect_uart_data_in) 
			);

	UART #(
		.NBIT_DATA(8),
		.NUM_TICKS(16),
		.BAUD_RATE(9600),
		.CLK_RATE(100000000)
		)
		u_uart(
			.CLK(CLK100MHZ),
			//.reset(reset),
			.tx_start(connect_uart_tx_start),
			.rx_bit(RX_INPUT),
			.data_in(connect_uart_data_in),   //((1 & estamos_en_test_bench) ? uart_in_debug : connect_uart_data_in),

			.data_out(connect_uart_data_out),
			.rx_done_tick(connect_uart_rx_done),
			.tx_bit(connect_tx_debug),
			.tx_done_tick(connect_uart_tx_done)
			);

	function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  	endfunction

endmodule
