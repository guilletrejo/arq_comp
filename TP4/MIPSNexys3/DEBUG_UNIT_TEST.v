`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:49:26 03/01/2019
// Design Name:   DEBUG_UNIT
// Module Name:   /home/guilletrejo/arq_comp/TP4/MIPSNexys3/DEBUG_UNIT_TEST.v
// Project Name:  MIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DEBUG_UNIT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DEBUG_UNIT_TEST;

	// Inputs
	reg clk;
	reg reset;
	reg halt;
	reg [7:0] test_reg;
	reg rx_done_tick;
	reg tx_done_tick;
	reg [7:0] rx_data_in;

	// Outputs
	wire [10:0] addr_mem_inst;
	wire [31:0] ins_to_mem;
	wire wr_ram_inst;
	wire [31:0] test;
	//wire flag;
	wire [2:0] substate_flag;
	wire [2:0] substatenext_flag;
	wire ctrl_clk_mips;
	wire debug;
	wire tx_start;
	wire [7:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	DEBUG_UNIT uut (
		.clk(clk), 
		.reset(reset), 
		.halt(halt), 
		.test_reg(test_reg), 
		.addr_mem_inst(addr_mem_inst), 
		.ins_to_mem(ins_to_mem), 
		.wr_ram_inst(wr_ram_inst), 
		.test(test), 
		//.flag(flag),
		.substate_flag(substate_flag),
		.substatenext_flag(substatenext_flag),
		.ctrl_clk_mips(ctrl_clk_mips), 
		.debug(debug), 
		.rx_done_tick(rx_done_tick), 
		.tx_done_tick(tx_done_tick), 
		.rx_data_in(rx_data_in), 
		.tx_start(tx_start), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		halt = 0;
		test_reg = 0;
		rx_done_tick = 0;
		tx_done_tick = 0;
		rx_data_in = 0;
        
		#200 clk=1;
		#200 clk=0;
		
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b00000001; // StartSignal
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b11011101; // LSB de la instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b11001100; // 2do LSB de la instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b10111011; // 3er LSB de la instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b10101010; // MSB de la instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b01000100; // LSB de la 2da instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b00110011; // 2do LSB de la 2da instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b00100010; // 3er LSB de la 2da instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b00010001; // MSB de la 2da instruccion
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b11111111; // LSB del halt
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b11111111; // LSB del halt
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b11111111; // LSB del halt
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_data_in = 8'b11111111; // MSB del halt
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b1;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
		rx_done_tick = 1'b0;
		
		#200 clk=1;
		#200 clk=0;
		#200 clk=1;
		#200 clk=0;
		
	end
      
endmodule

