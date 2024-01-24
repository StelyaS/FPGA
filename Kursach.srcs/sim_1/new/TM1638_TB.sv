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
reg DRIVER;
reg iclk;
reg rst;
reg CHAR1;
reg CHAR2;
reg CHAR3;
reg CHAR4;
wire stb;
wire dio;
wire oclk;

TM1638 uut (
.DRIVER(DRIVER),
.iclk(iclk),
.rst(rst),
.CHAR1(CHAR1),
.CHAR2(CHAR2),
.CHAR3(CHAR3),
.CHAR4(CHAR4),
.stb(stb),
.dio(dio),
.oclk(oclk)
);

initial
begin
DRIVER = 1'd0;
iclk = 1'd0;
rst = 1'd0;
#50 rst = 1'd1;
#5 rst = 1'd0;
#10 CHAR1 = 8'b1111_1111;
#1  CHAR2 = 8'b1111_1001;
#1  CHAR3 = 8'b1001_1001;
#1  CHAR4 = 8'b1000_0000;
#10000 DRIVER = 1'd1;
#1000 DRIVER = 1'd0;
#100000000 $finish;
end
always
begin
#5 iclk <= ~iclk;
//$display ("DRIVER=%b, i=%d, iclk=%b, bcd=%b, dec_out=%d%d%d%d", DRIVER, uut.i, uut.bin, uut.bcd, dec_out[3:0]);
end
endmodule
