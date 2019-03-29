`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author:
//			   Nestor Ortmann
//				Guillermo Trejo
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
// PROGRAMAR USANDO EL SIGUIENTE COMANDO: djtgcfg prog -d Basys2 --index 0 --file main.bit
//////////////////////////////////////////////////////////////////////////////////
module main
 
 #(parameter bits = 8)
 
 (
  input [bits-1:0] IN,
  input b1,
  input b2,
  input b3,
  input clk,
  output wire[bits-1:0] led_out
  );

reg [5:0] Op;
reg signed [bits-1:0] A;
reg signed [bits-1:0] B;

ALU alu(
	.Op(Op),.A(A), .B(B), .out(led_out)
);

always @(posedge clk)
begin
	if(b1)
		A = IN;
	else if(b2)
		B = IN;
	else if(b3)begin
		Op = IN;
	end
end

endmodule