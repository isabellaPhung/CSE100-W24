`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 03:26:41 PM
// Design Name: 
// Module Name: energybar
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


module energybar(
    input [14:0] energy,
    input [14:0] V,
    input [14:0] H,
    output energyOut
    );
    //20 px wide and near left border.
    //top edge when full, H = 16. bottom edge at H = 208
    //if btnU high, bar height -1 every frame
    //if btnU low, bar height < 192, +1 every frame
    assign energyOut = H > 15'd16 & H < 15'd36 & V > 15'd16+(15'd192-energy) & V < 15'd208;
endmodule
