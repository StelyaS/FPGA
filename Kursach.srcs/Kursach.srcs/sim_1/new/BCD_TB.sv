`timescale 1ns / 1ps

module BCD_TB;
//parameter BWIDTH = 14; //must avoid overflow
//parameter DWIDTH = 16; //must be multiple of 4
// Inputs
reg [13:0] bin_in;
reg clk;
reg rst;
reg rx;
// Outputs
wire [15:0] dec_out;
wire [3:0] dec_out1, dec_out10, dec_out100, dec_out1000;
// Instantiate the Unit Under Test (UUT)
BCD uut (
.bin_in(bin_in),
.clk(clk),
.rst(rst),
.rx(rx),
.dec_out(dec_out)
);
assign dec_out1 = dec_out[3:0];
assign dec_out10 = dec_out[7:4];
assign dec_out100 = dec_out[11:8];
assign dec_out1000 = dec_out[15:12];
initial
begin
bin_in = 'd0;
clk = 'd0;
rst = 'd0;
rx = 'd0;
#4 rst = 'd1;
#1 rst = 'd0;
#1 bin_in = 'd11;
#100 rx = 'd1;
#5 rx = 'd0;
#100 bin_in = 'd243;
#0 rx = 'd1;
#5 rx = 'd0;
#60 bin_in = 'd1423;
#0 rx = 'd1;
#5 rx = 'd0;
#100 $finish;
end
always
begin
#1 clk <= ~clk;
$display ("bin_in=%b, i=%d, bin=%b, bcd=%b, dec_out=%d%d%d%d", bin_in, uut.i, uut.bin, uut.bcd, dec_out[15:12], dec_out[11:8], dec_out[7:4], dec_out[3:0]);
end
endmodule
