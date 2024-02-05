`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2024 00:07:09
// Design Name: 
// Module Name: TM1638_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TM1638_TB;
//reg SWITCH;
reg iclk;
reg idata_rx;
//reg [0:31] idata;
reg [0:7] char_1;
reg [0:7] char_2;
reg [0:7] char_3;
reg [0:7] char_4;
reg rst;
wire stb;
wire dio;
wire oclk;

TM1638 uut (
//.SWITCH(SWITCH),
.iclk(iclk),
.idata_rx(idata_rx),
//.idata(idata),
.char_1(char_1),
.char_2(char_2),
.char_3(char_3),
.char_4(char_4),
.rst(rst),
.stb(stb),
.dio(dio),
.oclk(oclk)
);

initial
begin
idata_rx = 1'd0;
iclk = 1'd0;
rst = 1'd1;
#5000 rst = 1'd0;
#20 rst = 1'd1;
#10000 char_1 = 8'b1111_1110;
#1 char_2 = 8'b1111_1110;
#1 char_3 = 8'b1111_1110;
#1 char_4 = 8'b1111_1110;
//#100 idata = 32'b0011_0001_0011_0010_0011_0011_0011_0100;
#300000 idata_rx = 1'd1;
#200000 idata_rx = 1'd0;
#200000 idata_rx = 1'd1;
#200000 idata_rx = 1'd0;
#100000000 $finish;
end
always
begin
#5 iclk <= ~iclk;
end
endmodule
