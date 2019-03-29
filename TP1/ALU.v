`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author:
//			   Nestor Ortmann
//				Guillermo Trejo
// 
// Create Date:    16:33:07 09/05/2018 
// Design Name: 
// Module Name:    ALU 
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
//
//////////////////////////////////////////////////////////////////////////////////
module ALU

 #(parameter bits = 8)
 
 (
  input signed [5:0] Op, 
  input signed [bits-1:0] A, 
  input signed [bits-1:0] B, 
  output reg [bits-1:0] out
  );
 
 
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


    


endmodule
