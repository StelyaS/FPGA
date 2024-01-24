`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.01.2024 23:07:50
// Design Name: 
// Module Name: TM1638
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


module TM1638
(
    input logic DRIVER,
    input logic iclk,
    input logic rst,
    input logic CHAR1,
    input logic CHAR2,
    input logic CHAR3,
    input logic CHAR4,
    (*mark_debug="true"*)output logic stb,
    (*mark_debug="true"*)output logic dio,
    (*mark_debug="true"*)output logic oclk
);

    logic [4:0] cnt;
    logic [7:0] index = 8'd0;
    logic [3:0] word = 4'd0;
    logic [7:0] i = 8'd0;
    logic [4:0] j = 5'd0;
    logic int_clk = 1'd0;
    logic [2:0] state;
    localparam RESET = 3'd0;
    localparam IDLE = 3'd1;
    localparam CMD = 3'd2;
    localparam DATA = 3'd3;
    localparam DISPLAY = 3'd4;
    logic [2:0] data_state;
    localparam SET_CMD_1 = 3'd0;
    localparam SET_CMD_2 = 3'd1;
    localparam SET_DATA = 3'd2;
    localparam SET_CMD_3 = 3'd3;
    localparam [0:7] CMD_1 = 8'b00000010;
    localparam [0:7] CMD_2 = 8'b00000011;
    localparam [0:7] CMD_3 = 8'b11110001;
    localparam [0:7] D = 8'b01111010;
    localparam [0:7] A = 8'b11101110;
    localparam [0:7] T = 8'b00011110;

    logic [0:127] DATA_BUFF = {D, 8'd0, A, 8'd0, T, 8'd0, A, 8'd0, CHAR1, 8'd0, CHAR2, 8'd0, CHAR3, 8'd0, CHAR4, 8'd0};
 
    
always_ff @(posedge iclk)
    begin
    if (cnt < 5'd24) 
    cnt <= cnt+5'd1;
    else
    begin
    int_clk = ~int_clk; // 100MHz input clock -> 2MHz internal clock -> 1MHz output clock
    cnt <= 5'd0;
    end
    end
         
always_ff @(posedge int_clk or posedge rst)
    if (rst)
    state <= RESET;
    else
    begin        
case (state)
RESET:
    begin
    stb <= 1'd1;
    oclk <= 1'd1;
    i <= 8'd0;
    j <= 5'd0;
    dio <= 'd0;
    index <= 8'd0;
    word <= 4'd0;
    state <= IDLE;
    data_state <= SET_CMD_1;
    end
IDLE:
    begin
    stb <= !DRIVER;
    if (stb)
    state <= IDLE;
    else
    state <= CMD;
    end
CMD:
    begin
    state <= CMD; 
    if (i < 8'd16 || ( i > 8'd19) && (i < 8'd36))
    begin 
    i <= i+8'd1;
    stb <= 1'd0;
    oclk <= ~oclk;
    end
    else if ((i > 8'd15 && i < 8'd20) || i == 8'd36) 
    begin
    i <= i+8'd1;
    stb <= 1'd0;
    oclk <= 1'd1;
        if (i > 8'd16 && i < 8'd19)
        stb <= 1'd1;
    end
    else
    begin
    i <= 8'd0;
    stb <= 1'd0;
    oclk <= 1'd1;
    state <= DATA;
    end
    end
DATA:
    begin
    if (j < 5'd16)
    begin
    oclk <= 1'd1;
    state <= DATA;
        if (i < 8'd16)
        begin
        i <= i+8'd1;
        oclk <= ~oclk;
        end
        else
        begin
        i <= 8'd0;
        j <= j+5'd1;
        oclk <= 1'd1;
        end
    end
    else
    begin
    stb <= 1'd1;
    i <= 8'd0;
    j <= 5'd0;
    state <= DISPLAY;
    end
    end
DISPLAY:
    begin
    stb <= 1'd1;
    if (i > 8'd1 && i < 8'd18)
    begin
    i <= i+8'd1;
    stb <= 1'd0;
    oclk <= ~oclk;
    state <= DISPLAY;
    end
    else if (i == 8'd0)
    begin
    i <= i+8'd1;
    oclk <= 1'd1;
    stb <= 1'd1;
    state <= DISPLAY;  
    end 
    else if (i == 8'd1 || i == 8'd18)
    begin
    i <= i+8'd1;
    oclk <= 1'd1;
    stb <= 1'd0;
    state <= DISPLAY;
    end
    else
    begin
    i <= 8'd0;
    state <= IDLE;
    end
    end
default:     
    state <= IDLE;
endcase
    end
    
always_ff @ (negedge oclk)
    begin
case(data_state)
SET_CMD_1:
    begin
    dio <= CMD_1[index];
    index <= index + 8'd1;
    if (index == 8'd7)
    begin
    index <= 8'd0;
    data_state <= SET_CMD_2;
    end
    end
SET_CMD_2:
    begin
    dio <= CMD_2[index];
    index <= index + 8'd1;
    if (index == 8'd7)
    begin
    index <= 8'd0;
    data_state <= SET_DATA;
    end
    end
SET_DATA:
    begin
//    dio <= data_buff[index];
    dio <= index[0];
    index <= index + 8'd1;
    if (index == 8'd127)
    begin
    index <= 8'd0;
    data_state <= SET_CMD_3;
    end
    end    
SET_CMD_3:
    begin
    dio <= CMD_3[index];
    index <= index + 8'd1;
    if (index == 8'd7)
    begin
    index <= 8'd0;
    data_state <= SET_CMD_1;
    end
    end
    endcase        
    end
endmodule

