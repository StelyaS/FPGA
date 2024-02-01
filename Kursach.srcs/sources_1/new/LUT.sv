`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 15:57:14
// Design Name: 
// Module Name: LUT
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


module LUT
( 
    input logic iclk,
//    input logic rst,
    input logic [0:7] ilut,
    output logic [0:7] olut
);

always_ff @(posedge iclk)
//    begin
//    if (!rst)
//    begin
//    olut <= 8'b0000_0000;
//    end
//    else
    begin    
    if (ilut == 8'b0011_0000)
    olut <= 8'b1111_1100; // abcdefg "0"
    else if (ilut == 8'b0011_0001)
    olut <= 8'b0110_0000; // abcdefg "1"
    else if (ilut == 8'b0011_0010)
    olut <= 8'b1101_1010; // abcdefg "2"
    else if (ilut == 8'b0011_0011)
    olut <= 8'b1111_0010; // abcdefg "3"
    else if (ilut == 8'b0011_0100)
    olut <= 8'b0110_0110; // abcdefg "4"
    else if (ilut == 8'b0011_0101)
    olut <= 8'b1101_1010; // abcdefg "5"
    else if (ilut == 8'b0011_0110)
    olut <= 8'b1111_1010; // abcdefg "6"
    else if (ilut == 8'b0011_0111)
    olut <= 8'b0000_1110; // abcdefg "7"
    else if (ilut == 8'b0011_1000)
    olut <= 8'b1111_1110; // abcdefg "8"
    else if (ilut == 8'b0011_1001)
    olut <= 8'b1111_0110; // abcdefg "9"
    else
    olut <= 8'b0000_0000; // no LED
    end
//    end
endmodule
