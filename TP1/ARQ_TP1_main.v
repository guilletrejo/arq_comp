`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:27 08/23/2018 
// Design Name: 
// Module Name:    main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 						PROGRAMAR USANDO EL SIGUIENTE COMANDO: djtgcfg prog -d Basys2 --index 0 --file main.bit
//////////////////////////////////////////////////////////////////////////////////
module main
 
 #(parameter bits = 8)
 
 (
  input [bits-1:0] IN,
  input b1,
  input b2,
  input b3,
  input clk,
  output reg[bits-1:0] led_out
  );

reg signed [5:0] Op;
reg signed [bits-1:0] A;
reg signed [bits-1:0] B;
reg signed [bits-1:0] out;
 
always @(*)
begin
	 case (Op)
		6'b100000 : out = A + B; // ADD
		6'b100010 : out = A - B; // SUB
		6'b100100 : out = A & B; // AND
		6'b100101 : out = A | B; // OR
		6'b100110 : out = A ^ B; // XOR
		6'b000011 : out = A >>> B; // SRA
		6'b000010 : out = A >> B; // SRL
		6'b100111 : out = ~(A | B); // NOR
		default : out = 0;
	 endcase
end

always @(posedge clk)
begin
	if(b1)
		A = IN;
	else if(b2)
		B = IN;
	else if(b3)begin
		Op = IN;
		led_out=out;
	end
end


endmodule
