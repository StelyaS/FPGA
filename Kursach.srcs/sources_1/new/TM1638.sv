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
    (*mark_debug="true"*)input logic UART,
    input logic iclk,
    input logic SWITCH,
    (*mark_debug="true"*)input logic rst,
//    input logic [0:7] CHAR_1 = 8'b0110_0000,
//    input logic [0:7] CHAR_2 = 8'b1101_1010,
//    input logic [0:7] CHAR_3 = 8'b1111_0010,
//    input logic [0:7] CHAR_4 = 8'b0110_0110,
    (*mark_debug="true"*)output logic stb,
    (*mark_debug="true"*)output logic dio,
    (*mark_debug="true"*)output logic oclk
);
    logic [0:7] CHAR_1;
    logic [0:7] CHAR_2;
    logic [0:7] CHAR_3;
    logic [0:7] CHAR_4;
    logic [4:0] cnt;
    logic [7:0] index;
    logic [1:0] driver;
    logic [7:0] i;
    logic [4:0] j;
    (*mark_debug="true"*)logic intclk;
    localparam IDLE = 3'd1;
    localparam START = 3'd2;
    localparam CMD = 3'd3;
    localparam DATA = 3'd4;
    localparam DISPLAY = 3'd5;
    logic [2:0] state = IDLE;
    localparam SET_CMD_1 = 3'd1;
    localparam SET_CMD_2 = 3'd2;
    localparam SET_DATA = 3'd3;
    localparam SET_CMD_3 = 3'd4;
    logic [2:0] data_state = SET_CMD_1;
    localparam [0:7] CMD_1 = 8'b0000_0010;
    localparam [0:7] CMD_2 = 8'b0000_0011;
    localparam [0:7] CMD_3 = 8'b1111_0001;
    localparam [0:7] D = 8'b0111_1010;
    localparam [0:7] A = 8'b1110_1110;
    localparam [0:7] T = 8'b0001_1110;
    logic [0:127] DATA_BUFF;

    
always_ff @(posedge iclk)
    begin
    if (!rst)
    begin
    cnt <= 5'd0;
    intclk <= 1'd0;
    end
    else
    begin
    if (cnt < 5'd24) 
    cnt <= cnt+5'd1;
    else
    begin
    intclk = ~intclk; // 100MHz input clock -> 2MHz internal clock -> 1MHz output clock
    cnt <= 5'd0;
    end
    if (!SWITCH)
    begin
    CHAR_1 <= 8'b0110_0000;
    CHAR_2 <= 8'b1101_1010;
    CHAR_3 <= 8'b1111_0010;
    CHAR_4 <= 8'b0110_0110;
    end
    else
    begin
    CHAR_1 <= 8'b0110_0110;
    CHAR_2 <= 8'b1111_0010;
    CHAR_3 <= 8'b1101_1010;
    CHAR_4 <= 8'b0110_0000;
    end
    end 
    end
 
always_ff @(posedge intclk or negedge rst)
    begin
    if (!rst)
    begin
    stb <= 1'd1;
    i <= 8'd0;
    j <= 5'd0; 
    driver <= 2'd0;
    oclk <= 1'd1;
    state <= IDLE;
    end
    else
    begin
    if (UART && (driver == 2'd0))
    begin
    driver <= 2'd1;
    DATA_BUFF <= {D, 8'd0, A, 8'd0, T, 8'd0, A, 8'd0, CHAR_1, 8'd0, CHAR_2, 8'd0, CHAR_3, 8'd0, CHAR_4, 8'd0};
    end
    else if (UART && (driver == 2'd1))
    driver <= 2'd2;
    else if (!UART && (driver == 2'd2))
    driver <= 2'd0;      
case (state)
IDLE:
    begin
    if (driver == 2'd0)
    begin
    stb <= 1'd1;
    i <= 8'd0;
    j <= 5'd0;
    state <= IDLE;
    end
    else if (driver == 2'd1)
    state <= START;
    end
START:
    begin
    stb <= 1'd0;
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
    else if ((i > 8'd15 && i < 8'd20) || i == 8'd36) //!!!!
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
    end
    
always_ff @ (negedge oclk or negedge rst)
    begin
    if (!rst)
    begin
    dio <= 'd0;
    index <= 8'd0;  
    data_state <= SET_CMD_1;
    end
    else
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
    dio <= DATA_BUFF[index];
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
default:
    data_state <= SET_CMD_1;    
    endcase        
    end
endmodule


