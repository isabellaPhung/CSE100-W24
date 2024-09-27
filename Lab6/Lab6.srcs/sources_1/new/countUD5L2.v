`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 12:21:38 PM
// Design Name: 
// Module Name: countUD5L2
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


module countUD5L2(
    input UD, //up/down
    input CE, //clock edge
    input LD, //load
    input [4:0] Din, //load input
    input clk,
    output UTC,
    output DTC,
    output [4:0] Q
    );

endmodule
