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
	parameter cant_registros = 27,
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
	output [NBIT_DATA_LEN-1:0] led_fpga
);

    wire clk_mips;
    wire ctrl_clk_mips; 
	wire clk;
	//assign clk = CLK100MHZ; 
	//assign clk_mips = CLK100MHZ;
         //reset, 
         //reset_mips;
    
    wire connect_uart_rx_done,
	     connect_uart_tx_start,
	     connect_uart_tx_done,
		 //connect_reprogram,
		 connect_debug_mode,
		 connect_halt,
		 connect_tx_debug,
		 connect_wea_ram_inst;
		 
	wire [len_addr-1:0] connect_addr_mem_inst;
	wire [len_data-1:0] connect_ins_to_mem;

    wire [NBIT_DATA_LEN-1:0] connect_uart_data_in,
			                 connect_uart_data_out;

	//assign clk_mips = (ctrl_clk_mips) ? (!clk) : (1'b 0);

	assign TX_OUTPUT = connect_tx_debug;

	wire [len_bucket-1:0] bucket;

	wire debug_ram_flag;
	wire [len_data-1:0] debug_ram_addr;
	
	  my_clock instance_name
   (// Clock in ports
    .CLK_IN1(CLK100MHZ),      // IN
    // Clock out ports
    .CLK_OUT1(clk),     // OUT
    .CLK_OUT2(clk_mips));    // OUT

	TOP_MIPS #(
	.len_data(len_data),
	.num_bits(num_bits),
	.len_exec_bus(len_exec_bus),
	.len_mem_bus(len_mem_bus),
	.len_wb_bus(len_wb_bus)
	)
	u_top_mips(
		.clk(clk_mips),
		.ctrl_clk_mips(ctrl_clk_mips),
		.reset(SWITCH_RESET),// | reset_mips),

		//para debug
		.debug_flag(connect_debug_mode),
		.debug_ram_flag(debug_ram_flag),
		.debug_ram_addr(debug_ram_addr),
		.in_addr_mem_inst(connect_addr_mem_inst),
		.in_ins_to_mem(connect_ins_to_mem),
		.wea_ram_inst(connect_wea_ram_inst),
		
		.out_reg0_recolector(bucket[31:0]),
		.out_reg1_recolector(bucket[63:32]),
		.out_reg2_recolector(bucket[95:64]),
		.out_reg3_recolector(bucket[127:96]),
		.out_reg4_recolector(bucket[159:128]),
		.out_reg5_recolector(bucket[191:160]),
		.out_reg6_recolector(bucket[223:192]),
		.out_reg7_recolector(bucket[255:224]),
		.out_pc(bucket[287:256]),
		.data0(bucket[319:288]), // 36, 37, 38, 39 -> en estos valores va a estar el contador cuando
		.data1(bucket[351:320]), // 40, 41, 42, 43 -> se este pasando esta parte
		.data2(bucket[383:352]),
		.data3(bucket[415:384]),
		.Latch_IF_ID(bucket[511:448]), // Contiene 2 reg. de 32 bits: out_instruction y pc_branch_1_2
		.Latch_ID_EX(bucket[639:512]), // Contiene varios registros, en total 4 grupos de 32b: pc_branch_2_3, sign_extend, rs, rt, rd y buses de control
		.Latch_EX_MEM(bucket[767:640]), // Contiene 4 grupos de 32b
		.Latch_MEM_WB(bucket[863:768]), // Contiene 3 grupos de 32b

		.out_inst_test(led_fpga),
		.halt_flag(connect_halt)
		);

	DEBUG_UNIT #(
		.NBIT_DATA_LEN(NBIT_DATA_LEN),
        .len_data(len_data),
		.len_contador(clogb2(len_bucket/8)),
		.len_bucket(len_bucket)
		)
		u_debug_unit(
		    .clk(clk),
		    .reset(SWITCH_RESET),
		    .halt(connect_halt),
		    .bucket(bucket),

		    // outputs
		    .addr_mem_inst(connect_addr_mem_inst),
		    .ins_to_mem(connect_ins_to_mem),
		    //.reset_mips(reset_mips),
		    //.reprogram(connect_reprogram),
		    .ctrl_clk_mips(ctrl_clk_mips), // para parar el mips cuando esta grabando el programa/enviando resultados
			.debug(connect_debug_mode),
			.wr_ram_inst(connect_wea_ram_inst),

			.debug_ram_flag(debug_ram_flag),
			.debug_ram_addr(debug_ram_addr),
		
			.out_clk_counter(bucket[447:416]),

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
		.CLK_RATE(40000000)
		)
		u_uart(
			.CLK(clk),
			//.reset(reset),
			.tx_start(connect_uart_tx_start),
			.rx_bit(RX_INPUT),
			.data_in(connect_uart_data_in),  

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
