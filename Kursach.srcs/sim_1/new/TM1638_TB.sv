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
reg UART;
reg SWITCH;
reg iclk;
reg rst;
//reg CHAR_1;
//reg CHAR_2;
//reg CHAR_3;
//reg CHAR_4;
wire stb;
wire dio;
wire oclk;

TM1638 uut (
.UART(UART),
.SWITCH(SWITCH),
.iclk(iclk),
.rst(rst),
//.CHAR_1(CHAR_1),
//.CHAR_2(CHAR_2),
//.CHAR_3(CHAR_3),
//.CHAR_4(CHAR_4),
.stb(stb),
.dio(dio),
.oclk(oclk)
);

initial
begin
UART = 1'd0;
iclk = 1'd0;
rst = 1'd1;
#5000 rst = 1'd0;
#20 rst = 1'd1;
#10000 UART = 1'd1;
#200000 UART = 1'd0;
#200000 UART = 1'd1;
#200000 UART = 1'd0;
#100000000 $finish;
end
always
begin
#5 iclk <= ~iclk;
end
endmodule
