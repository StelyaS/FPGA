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
    input logic iclk, // 100 MHz input clock
    input logic rst, // reset
    input logic uart_rx_data, // UART input data
    output logic stb, // output strobe signal
    output logic dio, // data output
    output logic oclk // 1 MHz output clock
);
    logic [0:31] odata; // 32 bit in ascii 
    logic data_rx; // enabling signal for data transfering to TM1638 module
    logic [0:7] uart_data_1, uart_data_2, uart_data_3, uart_data_4; // 4 digits in ascii 
    logic [0:7] char_1, char_2, char_3, char_4; // 4 digits in 7_seg code

UART_RX uart_rx (.iclk(iclk), .rst(rst), .uart_rx_data(uart_rx_data), .odata(odata), .odata_rx(data_rx)); // UART_RX module 
    
always_ff @(posedge iclk) // 32 bit -> 4 digits
    begin
    uart_data_1 <= odata[0:7];
    uart_data_2 <= odata[8:15];
    uart_data_3 <= odata[16:23];
    uart_data_4 <= odata[24:31];
    end
    
LUT lut1 (.iclk(iclk), .ilut(uart_data_1), .olut(char_1)); // first digit into 7_seg code 
LUT lut2 (.iclk(iclk), .ilut(uart_data_2), .olut(char_2)); // second digit into 7_seg code
LUT lut3 (.iclk(iclk), .ilut(uart_data_3), .olut(char_3)); // third digit into 7_seg code
LUT lut4 (.iclk(iclk), .ilut(uart_data_4), .olut(char_4)); // fourth digit into 7_seg code

TM1638 tm1638 (.iclk(iclk), .idata_rx(data_rx), .char_1(char_1), .char_2(char_2), .char_3(char_3), .char_4(char_4),
.rst(rst), .stb(stb), .dio(dio), .oclk(oclk)); // TM1638 module 

endmodule
