`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 16:37:29
// Design Name: 
// Module Name: TOP
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


module TOP
(
    input logic iclk,
    (*mark_debug="true"*)input logic rst,
    (*mark_debug="true"*)input logic uart_rx_data,
    (*mark_debug="true"*)output logic stb,
    (*mark_debug="true"*)output logic dio,
    (*mark_debug="true"*)output logic oclk
);
    logic [0:31] odata;
    logic data_rx;
    (*mark_debug="true"*)logic [0:7] uart_data_1, uart_data_2, uart_data_3, uart_data_4;
    logic [0:7] char_1, char_2, char_3, char_4;

UART_RX uart_rx (.iclk(iclk), .rst(rst), .uart_rx_data(uart_rx_data), .odata(odata), .odata_rx(data_rx));
    
//always_ff @(posedge iclk)
always_ff @(posedge iclk)
    begin
    uart_data_1 <= odata[0:7];
    uart_data_2 <= odata[8:15];
    uart_data_3 <= odata[16:23];
    uart_data_4 <= odata[24:31];
    end
    
LUT lut1 (.iclk(iclk), .ilut(uart_data_1), .olut(char_1));
LUT lut2 (.iclk(iclk), .ilut(uart_data_2), .olut(char_2));
LUT lut3 (.iclk(iclk), .ilut(uart_data_3), .olut(char_3));
LUT lut4 (.iclk(iclk), .ilut(uart_data_4), .olut(char_4));

TM1638 tm1638 (.iclk(iclk), .idata_rx(data_rx), .char_1(char_1), .char_2(char_2), .char_3(char_3), .char_4(char_4),
.rst(rst), .stb(stb), .dio(dio), .oclk(oclk));

endmodule
