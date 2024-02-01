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
    input logic iclk, // 100 MHz input clock
    input logic idata_rx, // input drive signal from UART
//    input logic SWITCH, // to check 1234 - 4321 data programming
//    input logic [0:31] idata, // input data from UART
    input logic [0:7] char_1, // input char 1
    input logic [0:7] char_2, // input char 2
    input logic [0:7] char_3, // input char 3
    input logic [0:7] char_4, // input char 4
    input logic rst, // reset 
    output logic stb, // output strobe signal
    output logic dio, // data input-output channel
    output logic oclk // 1 MHz output clock
);

    logic [1:0] driver;
    
    logic [4:0] cnt; 
    logic intclk; // internal clock
    
    logic [7:0] index;
    logic [7:0] i;
    logic [4:0] j;
    
    logic [2:0] state;
    localparam IDLE = 3'd1;
    localparam START = 3'd2;
    localparam CMD = 3'd3;
    localparam DATA = 3'd4;
    localparam DISPLAY = 3'd5;
    
    logic [2:0] data_state;
    localparam SET_CMD_1 = 3'd1;
    localparam SET_CMD_2 = 3'd2;
    localparam SET_DATA = 3'd3;
    localparam SET_CMD_3 = 3'd4;
    
//    logic LUT_state;
    
    localparam [0:7] CMD_1 = 8'b0000_0010; // write data with auto increasing address mode 
    localparam [0:7] CMD_2 = 8'b0000_0011; // starting from address 00H
    localparam [0:7] CMD_3 = 8'b1111_0001; // set max display brightness
    
    localparam [0:7] D = 8'b0111_1010; // abcdefg "D"
    localparam [0:7] A = 8'b1110_1110; // abcdefg "A"
    localparam [0:7] T = 8'b0001_1110; // abcdefg "T"
    logic [0:127] DATA_BUFF; //={D, 8'd0, A, 8'd0, T, 8'd0, A, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0}; //!!

    
always_ff @(posedge iclk)
    begin
    if (!rst) // negative reset 
    begin
    cnt <= 5'd0;
    intclk <= 1'b0;
    end
    else
    begin
    if (cnt < 5'd24) // 100MHz input clock -> 2MHz internal clock
    cnt <= cnt+5'd1;
    else
    begin
    intclk = ~intclk; 
    cnt <= 5'd0;
    end
    end 
    end

 
always_ff @(posedge intclk or negedge rst) // to generate strobe signal and posedge output clock at specific time  
    begin
    if (!rst)
    begin
    stb <= 1'd1;
    i <= 8'd0;
    j <= 5'd0; 
    driver <= 2'd0;
    oclk <= 1'd1;
    DATA_BUFF <={D, 8'd0, A, 8'd0, T, 8'd0, A, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0, 8'd0};
    state <= IDLE;
    end
    else
    begin
    if (idata_rx && (driver == 2'd0)) // to block data from rewritting while drive signal from UART is active
    begin
    driver <= 2'd1;
    DATA_BUFF <= {D, 8'd0, A, 8'd0, T, 8'd0, A, 8'd0, char_1, 8'd0, char_2, 8'd0, char_3, 8'd0, char_4, 8'd0}; //!!!
    end
    else if (idata_rx && (driver == 2'd1))
    driver <= 2'd2;
    else if (!idata_rx && (driver == 2'd2))
    driver <= 2'd0;      
case (state)
IDLE: // waiting for driving signal 
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
START: // to generate 0.5 us delay between negedge stb and negedge oclk
    begin
    stb <= 1'd0;
    state <= CMD;
    end    
CMD: // for cmd 1 and cmd 2
    begin
    state <= CMD; 
    if (i < 8'd16 || ( i > 8'd19) && (i < 8'd36))
    begin 
    i <= i+8'd1;
    stb <= 1'd0;
    oclk <= ~oclk; // 2MHz internal clock -> 1MHz output clock
    end
    else if ((i > 8'd15 && i < 8'd20) || i == 8'd36)
    begin
    i <= i+8'd1;
    stb <= 1'd0;
    oclk <= 1'd1;
        if (i > 8'd16 && i < 8'd19) // to generate 1 us high stb signal between commands
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
DATA: // for data tx
    begin
    if (j < 5'd16) // for 16 data words 
    begin
    oclk <= 1'd1;
    state <= DATA;
        if (i < 8'd16) // for 8 bit word 
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
DISPLAY: // for cmd 3
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
    
always_ff @ (negedge oclk or negedge rst) // to generate stable data at posedge oclk
    begin
    if (!rst)
    begin
    dio <= 'd0;
    index <= 8'd0;  
    data_state <= SET_CMD_1;
    end
    else
case(data_state)
SET_CMD_1: // for cmd 1 data tx
    begin                 
    dio <= CMD_1[index];  
    index <= index + 8'd1;
    if (index == 8'd7)
    begin
    index <= 8'd0;
    data_state <= SET_CMD_2;
    end
    end
SET_CMD_2: // for cmd 2 data tx
    begin
    dio <= CMD_2[index];
    index <= index + 8'd1;
    if (index == 8'd7)
    begin
    index <= 8'd0;
    data_state <= SET_DATA;
    end
    end
SET_DATA: // for data tx
    begin
    dio <= DATA_BUFF[index];
    index <= index + 8'd1;
    if (index == 8'd127)
    begin
    index <= 8'd0;
    data_state <= SET_CMD_3;
    end
    end    
SET_CMD_3: // for cmd 3 tx
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


