`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 03:34:28 PM
// Design Name: 
// Module Name: PixelAddress
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


module PixelAddress(
    input clk,
    output [14:0] V,
    output [14:0] H
    );
wire Vreset, Hreset;
assign Vreset = V == 524;//row, height high when V = 525
assign Hreset = H == 799;//col, width high when H = 800
countUD15L widthCount(.CE(1'b1), .UD(1'b1), .LD(Hreset), .clk(clk), .Din(15'b0), .Q(H)); //width, counts up to 800 every clock
countUD15L heightCount(.CE(Hreset), .UD(1'b1), .LD(Vreset & Hreset), .clk(clk), .Din(15'b0), .Q(V)); //height, counts up to 525 every clock
endmodule
