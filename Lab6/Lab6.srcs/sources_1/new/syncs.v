`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 03:34:28 PM
// Design Name: 
// Module Name: syncs
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


module syncs(
    input [14:0] V,
    input [14:0] H,
    output Vsync,
    output Hsync
    );
assign Vsync = V != 15'd489 & V != 15'd490; //1 as long as V is not 489 or 490
assign Hsync = ~(H >= 15'd655 & H <= 15'd750); //1 as long as H is not in range 655-750
endmodule
