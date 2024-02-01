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
reg [0:31] idata;
reg rst;
//reg CHAR_1;
//reg CHAR_2;
//reg CHAR_3;
//reg CHAR_4;
wire stb;
wire dio;
wire oclk;

TM1638 uut (
//.SWITCH(SWITCH),
.iclk(iclk),
.idata_rx(idata_rx),
.rst(rst),
.idata(idata),
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
idata_rx = 1'd0;
iclk = 1'd0;
rst = 1'd1;
idata = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
#5000 rst = 1'd0;
#20 rst = 1'd1;
#100 idata = 32'b0011_0001_0011_0010_0011_0011_0011_0100;
#10000 idata_rx = 1'd1;
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
