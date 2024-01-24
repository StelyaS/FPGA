`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.12.2023 15:33:35
// Design Name: 
// Module Name: BCD
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
module BCD
(
    input logic [13:0] bin_in,
    input logic clk,
    input logic rst,
    input logic rx,
    output logic [15:0] dec_out
);
    logic [13:0] bin;
    logic [15:0] bcd;
    logic [2:0] state;
    logic [3:0] i;
    logic rx_state;
    localparam RESET = 3'd0;
    localparam START = 3'd1;
    localparam SHIFT = 3'd2;
    localparam ADD = 3'd3;
    localparam DONE = 3'd4;
    localparam IDLE = 3'd5;
always_ff @ (posedge clk or posedge rst)
    if (rst)
    state <= RESET;
    else
    begin
    state <= IDLE;
case (state)
RESET:
    begin
    rx_state <= 'd0;
    bin <= 'd0;
    i <= 'd0;
    bcd <= 'd0;
    dec_out <= 'd0;
    end
IDLE:
    begin
    rx_state <= rx;
    if (!rx_state)
    state <= IDLE;
    else
    state <= START;
    end
START:
    begin
    rx_state <= 'd0;
    bin <= bin_in;
    bcd <= 'd0;
    state <= SHIFT;
    end
SHIFT:
    begin
    bin <= {bin [12:0], 1'd0};
    bcd <= {bcd [14:0], bin[13]};
    i <= i + 4'd1;
    if (i == 4'd13)
    state <= DONE;
    else
    state <= ADD;
    end
ADD:
    begin
    if (bcd[3:0] > 'd4)
    begin
    bcd[3:0] <= bcd[3:0] + 4'd3;
    end
    if (bcd[7:4] > 'd4)
    begin
    bcd[7:4] <= bcd[7:4] + 4'd3;
    end
    if (bcd[11:8] > 'd4)
    begin
    bcd[11:8] <= bcd[11:8] + 4'd3;
    end
    if (bcd[15:12] > 'd4)
    begin
    bcd[15:12] <= bcd[15:12] + 4'd3;
    end
    state <= SHIFT;
    end
DONE:
    begin
    dec_out <= bcd;
    i <= 4'd0;
    state <= IDLE;
    end
default:
    state <= IDLE;
endcase
end
endmodule