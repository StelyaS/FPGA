`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.01.2024 17:05:34
// Design Name: 
// Module Name: UART_RX_TB
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


module UART_RX_TB;
reg iclk;
reg rst;
reg uart_rx_data;
wire odata;
wire odata_rx;

UART_RX uut (
.iclk(iclk),
.rst(rst),
.uart_rx_data(uart_rx_data),
.odata(odata),
.odata_rx(odata_rx)
);

initial
begin
iclk = 1'd0;
rst = 1'd1;
uart_rx_data = 1'd1;
#5000 rst = 1'd0;
#20 rst = 1'd1;
#18000 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#180000 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd0;
#8680 uart_rx_data = 1'd1;
#8680 uart_rx_data = 1'd1;
#100000000 $finish;
end
always
begin
#5 iclk <= ~iclk;
end
endmodule
