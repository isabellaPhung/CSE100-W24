`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:03:00 PM
// Design Name: 
// Module Name: Game_Counter
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

//serves as game countdown
module Game_Counter(
    input CE,
    input R,
    output [4:0] Q,
    input clk
    );
//always decrementing counter
countUD5L count(.UD(1'b0), .CE(CE|R), .LD(R), .Din(5'h1F),  .clk(clk), .Q(Q));
endmodule
