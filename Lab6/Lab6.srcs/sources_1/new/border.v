`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 03:05:19 PM
// Design Name: 
// Module Name: border
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


module border(
    input [14:0] V,
    input [14:0] H,
    output borderOut
    );
//top edge: 1 when V is 0-639 and H is 0-8
//bottom edge: 1 when V is 0-639 and H is 471-479
//left edge: 1 when V is 0-7 and H is 0-479
//right edge: 1 when V is 631-639 and H is 0-479
assign borderOut = H<15'd639 & V < 15'd8 | H<15'd639 & V > 15'd471 & V < 15'd479 | H<15'd7 & V < 15'd479 | H>15'd631 & H<15'd639 & V < 15'd479;
endmodule
