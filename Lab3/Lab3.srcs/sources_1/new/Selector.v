`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2024 02:03:00 PM
// Design Name: 
// Module Name: Selector
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


module Selector(
    input [3:0] sel,
    input [15:0] N,
    output [3:0] H
    );

    wire [3:0] a, b, c, d;
    assign a = N[15:12];
    assign b = N[11:8];
    assign c = N[7:4];
    assign d = N[3:0];
    
    assign H = (d & {4{sel[0]}}) | (c & {4{sel[1]}}) | (b & {4{sel[2]}}) | (a & {4{sel[3]}});
endmodule
