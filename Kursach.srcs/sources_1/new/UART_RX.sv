`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2024 16:55:35
// Design Name: 
// Module Name: UART_RX
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


module UART_RX
(
    input logic iclk,
    (*mark_debug="true"*)input logic rst,
    (*mark_debug="true"*)input logic uart_rx_data,
//    output logic [0:31] odata,
    (*mark_debug="true"*)output logic odata_rx
);

    localparam BAUD_RATE = 115200;
    localparam CLK_HZ = 100_000_000;
    localparam CLOCK_PER_BIT = CLK_HZ / BAUD_RATE;
    localparam COUNT_REG_LENGTH = $clog2(CLOCK_PER_BIT);
  
    logic [COUNT_REG_LENGTH-1:0] cnt;  
    logic intclk; // internal clock
    
    logic [2:0] i;
    logic [1:0] j;
    
    logic [2:0] state;
    localparam IDLE = 3'd0;
    localparam DATA = 3'd1;
    localparam STOP = 3'd2;
    
    logic [7:0] rx_data;
//    logic data_bit;
    (*mark_debug="true"*)logic [0:31] odata;
    
always_ff @(posedge iclk)
    begin
    if (!rst) 
    begin
    cnt <= 10'd0;
    intclk <= 1'd0;
    end
    else
    begin
    if (cnt == CLOCK_PER_BIT/2) 
    begin
    intclk = ~intclk; 
    cnt <= 10'd0;
    end 
    else
    cnt <= cnt+10'd1;
    end
    end 
    
always_ff @(posedge intclk) // ??
    begin 
    if (!rst)
    begin
    i <= 3'd0;
    j <= 2'd0;
    state <= IDLE;
    rx_data <= 8'd0;
    odata_rx <= 1'd0;
    odata <= 32'd0;
    end
    else
    begin
case (state)
IDLE:
    begin
    i <= 3'd0;
    rx_data <= 8'd0;
    if (uart_rx_data && (j != 2'd0)) // to send data[0:31]
    begin
    j <= 2'd0;
    odata_rx <= 1'd1;
    state <= IDLE;
    end
    else if (uart_rx_data)
    begin
    j <= 2'd0;
    odata_rx <= 1'd0;
    odata <= 32'd0;
    state <= IDLE;
    end
    else if (!uart_rx_data)
    state <= DATA;
    end
DATA:
    begin
    state <= DATA;
    if (i < 3'd7)
    begin
    rx_data[i] <= uart_rx_data;
    i <= i+3'd1;
    end
    else
    begin
    rx_data[i] <= uart_rx_data;
    i <= 3'd0;
    state <= STOP;
    end
    end
STOP:
    begin
    if (j == 2'd0)
    begin
    odata[0:7] <= rx_data[7:0];
    j <= j+2'd1;
    state <= IDLE;
    end
    else if (j == 2'd1)
    begin
    odata[8:15] <= rx_data[7:0];
    j <= j+2'd1;
    state <= IDLE;
    end
    else if (j == 2'd2)
    begin
    odata[16:23] <= rx_data[7:0];
    j <= j+2'd1;
    state <= IDLE;
    end
    else if (j == 2'd3)
    begin
    odata[24:31] <= rx_data[7:0];
    j <= 2'd3;
    state <= IDLE;
    end
    end
default:     
    state <= IDLE;            
endcase
    end
    end 
endmodule
