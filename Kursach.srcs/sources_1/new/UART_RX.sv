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
    input logic iclk, // 100 MHz input clock
    input logic rst, // reset
    input logic uart_rx_data, // input signal from Terminal (data + start and stop bits)
    output logic [0:31] odata, // output data from UART
    output logic odata_rx // output drive signal from UART
);

    localparam BAUD_RATE = 115200; // UART baud rate
    localparam CLK_HZ = 100_000_000; // 100 MHz clock
    localparam CLOCK_PER_BIT = CLK_HZ / BAUD_RATE; // clocks per bit 
    localparam COUNT_REG_LENGTH = $clog2(CLOCK_PER_BIT); // size of counter register
  
    logic [COUNT_REG_LENGTH-1:0] cnt;  
    logic intclk; // internal clock
    
    logic [2:0] i;
    logic [1:0] j;
    
    logic [2:0] state;
    localparam IDLE = 3'd0;
    localparam DATA = 3'd1;
    localparam STOP = 3'd2;
    
    logic [7:0] rx_data; // internal data buffer
//    logic [0:31] odata;
    
always_ff @(posedge iclk)
    begin
    if (!rst) // negative reset
    begin
    cnt <= 10'd0;
    intclk <= 1'd0;
    end
    else
    begin
    if (cnt == CLOCK_PER_BIT/2)  // 100 MHz input clock -> 115 207 KHz internal clock (for selected baud rate)
    begin
    intclk = ~intclk; 
    cnt <= 10'd0;
    end 
    else
    cnt <= cnt+10'd1;
    end
    end 
    
always_ff @(posedge intclk) // to read input data 
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
    else if (uart_rx_data) // waiting for data
    begin
    j <= 2'd0;
    odata_rx <= 1'd0;
    odata <= 32'd0;
    state <= IDLE;
    end
    else if (!uart_rx_data) // start bit 
    state <= DATA;
    end
DATA:
    begin
    state <= DATA;
    if (i < 3'd7) // to fill internal data buffer
    begin
    rx_data[i] <= uart_rx_data;
    i <= i+3'd1;
    end
    else
    begin
    rx_data[i] <= uart_rx_data;
    i <= 3'd0; // last bit of data
    state <= STOP; 
    end
    end
STOP:
    begin
    if (j == 2'd0) // first byte
    begin
    odata[0:7] <= rx_data[7:0];
    j <= j+2'd1;
    state <= IDLE;
    end
    else if (j == 2'd1) // second byte
    begin
    odata[8:15] <= rx_data[7:0];
    j <= j+2'd1;
    state <= IDLE;
    end
    else if (j == 2'd2) // third byte
    begin
    odata[16:23] <= rx_data[7:0];
    j <= j+2'd1;
    state <= IDLE;
    end
    else if (j == 2'd3) // fourth byte 
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
