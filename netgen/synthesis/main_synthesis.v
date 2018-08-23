////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: main_synthesis.v
// /___/   /\     Timestamp: Thu Aug 16 12:11:17 2018
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -insert_glbl true -w -dir netgen/synthesis -ofmt verilog -sim main.ngc main_synthesis.v 
// Device	: xc3s700a-4-fg484
// Input file	: main.ngc
// Output file	: C:\Users\Guille\ARQ_TP1_ALU\netgen\synthesis\main_synthesis.v
// # of Modules	: 1
// Design Name	: main
// Xilinx        : C:\Xilinx_ISE\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module main (
out, A, B, Op
);
  output [3 : 0] out;
  input [3 : 0] A;
  input [3 : 0] B;
  input [5 : 0] Op;
  wire A_0_IBUF_4;
  wire A_1_IBUF_5;
  wire A_2_IBUF_6;
  wire A_3_IBUF_7;
  wire B_0_IBUF_12;
  wire B_1_IBUF_13;
  wire B_2_IBUF_14;
  wire B_3_IBUF_15;
  wire N01;
  wire N38;
  wire N40;
  wire N42;
  wire N46;
  wire N48;
  wire N50;
  wire N52;
  wire N53;
  wire N54;
  wire N55;
  wire N6;
  wire N9;
  wire Op_0_IBUF_36;
  wire Op_1_IBUF_37;
  wire Op_2_IBUF_38;
  wire Op_3_IBUF_39;
  wire Op_4_IBUF_40;
  wire Op_5_IBUF_41;
  wire \out<0>103_43 ;
  wire \out<0>105_44 ;
  wire \out<0>146_45 ;
  wire \out<0>32_46 ;
  wire \out<0>37_47 ;
  wire \out<1>106_49 ;
  wire \out<1>122_50 ;
  wire \out<1>13 ;
  wire \out<1>131_52 ;
  wire \out<1>132_53 ;
  wire \out<1>89_54 ;
  wire \out<1>92_55 ;
  wire \out<2>12_57 ;
  wire \out<2>121_58 ;
  wire \out<2>85_59 ;
  wire \out<3>11 ;
  wire \out<3>111_62 ;
  wire \out<3>179_63 ;
  wire \out<3>311_64 ;
  wire \out<3>324_65 ;
  wire out_0_OBUF_66;
  wire out_1_OBUF_67;
  wire out_2_OBUF_68;
  wire out_3_OBUF_69;
  wire out_mux00001;
  wire [2 : 2] Maddsub_out_addsub0000_lut;
  LUT4 #(
    .INIT ( 16'h0004 ))
  \out<3>311  (
    .I0(B_1_IBUF_13),
    .I1(Op_1_IBUF_37),
    .I2(Op_5_IBUF_41),
    .I3(Op_2_IBUF_38),
    .O(\out<3>311_64 )
  );
  LUT4 #(
    .INIT ( 16'h0001 ))
  \out<3>324  (
    .I0(Op_4_IBUF_40),
    .I1(Op_3_IBUF_39),
    .I2(B_3_IBUF_15),
    .I3(B_2_IBUF_14),
    .O(\out<3>324_65 )
  );
  LUT2 #(
    .INIT ( 4'h8 ))
  \out<3>325  (
    .I0(\out<3>311_64 ),
    .I1(\out<3>324_65 ),
    .O(N9)
  );
  LUT4 #(
    .INIT ( 16'hE475 ))
  \out<1>3_SW0  (
    .I0(Op_5_IBUF_41),
    .I1(Op_2_IBUF_38),
    .I2(Op_0_IBUF_36),
    .I3(Op_1_IBUF_37),
    .O(N38)
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \out<1>3  (
    .I0(Op_4_IBUF_40),
    .I1(Op_3_IBUF_39),
    .I2(N38),
    .O(N6)
  );
  LUT3 #(
    .INIT ( 8'h01 ))
  \out<0>32  (
    .I0(B_3_IBUF_15),
    .I1(B_2_IBUF_14),
    .I2(Op_5_IBUF_41),
    .O(\out<0>32_46 )
  );
  LUT4 #(
    .INIT ( 16'h2880 ))
  \out<0>103  (
    .I0(Op_2_IBUF_38),
    .I1(A_0_IBUF_4),
    .I2(B_0_IBUF_12),
    .I3(Op_1_IBUF_37),
    .O(\out<0>103_43 )
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  \out<0>105  (
    .I0(N6),
    .I1(\out<0>37_47 ),
    .I2(\out<0>103_43 ),
    .O(\out<0>105_44 )
  );
  LUT3 #(
    .INIT ( 8'hEA ))
  \out<0>161  (
    .I0(\out<0>105_44 ),
    .I1(Op_5_IBUF_41),
    .I2(\out<0>146_45 ),
    .O(out_0_OBUF_66)
  );
  LUT3 #(
    .INIT ( 8'h96 ))
  \Maddsub_out_addsub0000_lut<2>1  (
    .I0(out_mux00001),
    .I1(B_2_IBUF_14),
    .I2(A_2_IBUF_6),
    .O(Maddsub_out_addsub0000_lut[2])
  );
  LUT4 #(
    .INIT ( 16'h2880 ))
  \out<1>89  (
    .I0(Op_2_IBUF_38),
    .I1(A_1_IBUF_5),
    .I2(B_1_IBUF_13),
    .I3(Op_1_IBUF_37),
    .O(\out<1>89_54 )
  );
  LUT4 #(
    .INIT ( 16'hFFF8 ))
  \out<1>92  (
    .I0(\out<1>13 ),
    .I1(\out<0>32_46 ),
    .I2(N6),
    .I3(\out<1>89_54 ),
    .O(\out<1>92_55 )
  );
  LUT3 #(
    .INIT ( 8'hC8 ))
  \out<1>106  (
    .I0(A_1_IBUF_5),
    .I1(Op_0_IBUF_36),
    .I2(B_1_IBUF_13),
    .O(\out<1>106_49 )
  );
  LUT4 #(
    .INIT ( 16'hFAF8 ))
  \out<1>144  (
    .I0(Op_5_IBUF_41),
    .I1(\out<1>106_49 ),
    .I2(\out<1>92_55 ),
    .I3(\out<1>122_50 ),
    .O(out_1_OBUF_67)
  );
  LUT4 #(
    .INIT ( 16'hA280 ))
  \out<2>12  (
    .I0(N9),
    .I1(B_0_IBUF_12),
    .I2(A_3_IBUF_7),
    .I3(A_2_IBUF_6),
    .O(\out<2>12_57 )
  );
  LUT4 #(
    .INIT ( 16'h0E68 ))
  \out<2>85  (
    .I0(B_2_IBUF_14),
    .I1(A_2_IBUF_6),
    .I2(Op_1_IBUF_37),
    .I3(Op_0_IBUF_36),
    .O(\out<2>85_59 )
  );
  LUT4 #(
    .INIT ( 16'h0009 ))
  \out<2>121  (
    .I0(Maddsub_out_addsub0000_lut[2]),
    .I1(N01),
    .I2(Op_0_IBUF_36),
    .I3(Op_2_IBUF_38),
    .O(\out<2>121_58 )
  );
  LUT3 #(
    .INIT ( 8'hFE ))
  out_mux0000_SW0 (
    .I0(Op_2_IBUF_38),
    .I1(Op_1_IBUF_37),
    .I2(Op_0_IBUF_36),
    .O(N40)
  );
  LUT4 #(
    .INIT ( 16'hFEFF ))
  out_mux0000 (
    .I0(N40),
    .I1(Op_4_IBUF_40),
    .I2(Op_3_IBUF_39),
    .I3(Op_5_IBUF_41),
    .O(out_mux00001)
  );
  IBUF   A_3_IBUF (
    .I(A[3]),
    .O(A_3_IBUF_7)
  );
  IBUF   A_2_IBUF (
    .I(A[2]),
    .O(A_2_IBUF_6)
  );
  IBUF   A_1_IBUF (
    .I(A[1]),
    .O(A_1_IBUF_5)
  );
  IBUF   A_0_IBUF (
    .I(A[0]),
    .O(A_0_IBUF_4)
  );
  IBUF   B_3_IBUF (
    .I(B[3]),
    .O(B_3_IBUF_15)
  );
  IBUF   B_2_IBUF (
    .I(B[2]),
    .O(B_2_IBUF_14)
  );
  IBUF   B_1_IBUF (
    .I(B[1]),
    .O(B_1_IBUF_13)
  );
  IBUF   B_0_IBUF (
    .I(B[0]),
    .O(B_0_IBUF_12)
  );
  IBUF   Op_5_IBUF (
    .I(Op[5]),
    .O(Op_5_IBUF_41)
  );
  IBUF   Op_4_IBUF (
    .I(Op[4]),
    .O(Op_4_IBUF_40)
  );
  IBUF   Op_3_IBUF (
    .I(Op[3]),
    .O(Op_3_IBUF_39)
  );
  IBUF   Op_2_IBUF (
    .I(Op[2]),
    .O(Op_2_IBUF_38)
  );
  IBUF   Op_1_IBUF (
    .I(Op[1]),
    .O(Op_1_IBUF_37)
  );
  IBUF   Op_0_IBUF (
    .I(Op[0]),
    .O(Op_0_IBUF_36)
  );
  OBUF   out_3_OBUF (
    .I(out_3_OBUF_69),
    .O(out[3])
  );
  OBUF   out_2_OBUF (
    .I(out_2_OBUF_68),
    .O(out[2])
  );
  OBUF   out_1_OBUF (
    .I(out_1_OBUF_67),
    .O(out[1])
  );
  OBUF   out_0_OBUF (
    .I(out_0_OBUF_66),
    .O(out[0])
  );
  LUT4 #(
    .INIT ( 16'h1000 ))
  \out<3>179  (
    .I0(Op_3_IBUF_39),
    .I1(Op_4_IBUF_40),
    .I2(Op_5_IBUF_41),
    .I3(N42),
    .O(\out<3>179_63 )
  );
  LUT4 #(
    .INIT ( 16'hBAAA ))
  \out<3>191  (
    .I0(\out<3>179_63 ),
    .I1(B_0_IBUF_12),
    .I2(A_3_IBUF_7),
    .I3(N9),
    .O(out_3_OBUF_69)
  );
  LUT4 #(
    .INIT ( 16'h3A53 ))
  \out<3>135_SW0  (
    .I0(out_mux00001),
    .I1(B_2_IBUF_14),
    .I2(N01),
    .I3(A_2_IBUF_6),
    .O(N46)
  );
  LUT4 #(
    .INIT ( 16'hC888 ))
  \out<2>156_SW0  (
    .I0(\out<2>121_58 ),
    .I1(Op_5_IBUF_41),
    .I2(Op_2_IBUF_38),
    .I3(\out<2>85_59 ),
    .O(N48)
  );
  LUT4 #(
    .INIT ( 16'hABAA ))
  \out<2>156  (
    .I0(\out<2>12_57 ),
    .I1(Op_3_IBUF_39),
    .I2(Op_4_IBUF_40),
    .I3(N48),
    .O(out_2_OBUF_68)
  );
  LUT4 #(
    .INIT ( 16'hAB8C ))
  \out<0>146  (
    .I0(Op_0_IBUF_36),
    .I1(A_0_IBUF_4),
    .I2(Op_2_IBUF_38),
    .I3(B_0_IBUF_12),
    .O(\out<0>146_45 )
  );
  LUT3 #(
    .INIT ( 8'h9F ))
  \out<1>122_SW0  (
    .I0(A_0_IBUF_4),
    .I1(out_mux00001),
    .I2(B_0_IBUF_12),
    .O(N50)
  );
  LUT4 #(
    .INIT ( 16'h1441 ))
  \out<1>122  (
    .I0(Op_2_IBUF_38),
    .I1(B_1_IBUF_13),
    .I2(A_1_IBUF_5),
    .I3(N50),
    .O(\out<1>122_50 )
  );
  MUXF5   \out<0>37  (
    .I0(N52),
    .I1(N53),
    .S(B_0_IBUF_12),
    .O(\out<0>37_47 )
  );
  LUT4 #(
    .INIT ( 16'hA280 ))
  \out<0>37_F  (
    .I0(\out<0>32_46 ),
    .I1(B_1_IBUF_13),
    .I2(A_2_IBUF_6),
    .I3(A_0_IBUF_4),
    .O(N52)
  );
  LUT4 #(
    .INIT ( 16'hA280 ))
  \out<0>37_G  (
    .I0(\out<0>32_46 ),
    .I1(B_1_IBUF_13),
    .I2(A_3_IBUF_7),
    .I3(A_1_IBUF_5),
    .O(N53)
  );
  MUXF5   \out<3>179_SW0  (
    .I0(N54),
    .I1(N55),
    .S(Op_2_IBUF_38),
    .O(N42)
  );
  LUT4 #(
    .INIT ( 16'h1441 ))
  \out<3>179_SW0_F  (
    .I0(Op_0_IBUF_36),
    .I1(A_3_IBUF_7),
    .I2(B_3_IBUF_15),
    .I3(N46),
    .O(N54)
  );
  LUT4 #(
    .INIT ( 16'h0E68 ))
  \out<3>179_SW0_G  (
    .I0(B_3_IBUF_15),
    .I1(A_3_IBUF_7),
    .I2(Op_1_IBUF_37),
    .I3(Op_0_IBUF_36),
    .O(N55)
  );
  LUT2 #(
    .INIT ( 4'h4 ))
  \out<1>131  (
    .I0(B_0_IBUF_12),
    .I1(A_3_IBUF_7),
    .O(\out<1>131_52 )
  );
  LUT3 #(
    .INIT ( 8'hD8 ))
  \out<1>132  (
    .I0(B_0_IBUF_12),
    .I1(A_2_IBUF_6),
    .I2(A_1_IBUF_5),
    .O(\out<1>132_53 )
  );
  MUXF5   \out<1>13_f5  (
    .I0(\out<1>132_53 ),
    .I1(\out<1>131_52 ),
    .S(B_1_IBUF_13),
    .O(\out<1>13 )
  );
  LUT4 #(
    .INIT ( 16'h22B2 ))
  \out<3>111  (
    .I0(B_1_IBUF_13),
    .I1(A_1_IBUF_5),
    .I2(B_0_IBUF_12),
    .I3(A_0_IBUF_4),
    .O(\out<3>11 )
  );
  LUT4 #(
    .INIT ( 16'h175F ))
  \out<3>112  (
    .I0(B_1_IBUF_13),
    .I1(A_0_IBUF_4),
    .I2(A_1_IBUF_5),
    .I3(B_0_IBUF_12),
    .O(\out<3>111_62 )
  );
  MUXF5   \out<3>11_f5  (
    .I0(\out<3>111_62 ),
    .I1(\out<3>11 ),
    .S(out_mux00001),
    .O(N01)
  );
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

