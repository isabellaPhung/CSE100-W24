`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2024 04:39:22 PM
// Design Name: 
// Module Name: AN0
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

//Isabella Phung
//itphung
//1702285
//1/9/2024
//CSE100
module AN0(
    input d2,
    input d1,
    input d0,
    input btnD,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output AN3,
    output AN2,
    output AN1,
    output AN0
    );
    assign CA = (~d2 * ~d1 * d0) + (d2 * ~d1 * ~d0);
    assign CB = (d2 * ~d1 * d0) + (d2 * d1 * ~d0);
    assign CC = (~d2 * d1 * ~d0);
    assign CD = (~d2 * ~d1 * d0) + (d2 * ~d1 * ~d0) + (d2 * d1 * d0);
    assign CE = (~d2 * ~d1 * d0) + (~d2 * d1 * d0) + (d2 * ~d1 * ~d0) + (d2 * ~d1 * d0) + (d2 * d1 * d0);
    assign CF = (~d2 * ~d1 * d0) + (~d2 * d1 * ~d0) + (~d2 * d1 * d0) + (d2 * d1 * d0);
    assign CG = (~d2 * ~d1 * ~d0) + (~d2 * ~d1 * d0) + (d2 * d1 * d0);
    assign DP = btnD;
    assign AN3 = 1;
    assign AN2 = 1;
    assign AN1 = 1;
    assign AN0 = 0;
endmodule
