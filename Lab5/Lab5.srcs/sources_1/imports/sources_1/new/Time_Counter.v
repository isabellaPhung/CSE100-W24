`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:03:00 PM
// Design Name: 
// Module Name: Time_Counter
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

//serves as time counter for flashing for specific intervals of time
module Time_Counter(
    input CE,
    input R,
    input clk,
    output [4:0] Q
    );
//always incrementing counter
countUD5L count(.UD(1'b1), .CE(CE|R), .LD(R), .Din(5'h00), .clk(clk), .Q(Q));

endmodule
