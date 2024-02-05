`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 16:37:57
// Design Name: 
// Module Name: TOP_TB
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


module TOP_TB;
reg iclk;
reg rst;
reg uart_rx_data;
wire stb;
wire dio;
wire oclk;

TOP uut (
.iclk(iclk),
.rst(rst),
.uart_rx_data(uart_rx_data),
.stb(stb),
.dio(dio),
.oclk(oclk)
);

initial
begin
iclk = 1'd0;
rst = 1'd1;
uart_rx_data = 1'd1;
#5000 rst = 1'd0;
#20 rst = 1'd1;
#180000 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1; // 8.68 us for 1 bit (100_000_000/115_200) 
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#300000 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#100000000 $finish;
end
always
begin
#5 iclk <= ~iclk;
end
endmodule
