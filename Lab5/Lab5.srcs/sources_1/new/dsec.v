`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 03:29:28 PM
// Design Name: 
// Module Name: dsec
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


module dsec(
    input qsec,
    input clk,
    output dsec
    );
wire [3:0] ring;
RingCounter doubleCounter(.Advance(qsec), .clk(clk), .out(ring));
assign dsec = qsec & (&(~(ring^4'b0010)) | &(~(ring^4'b1000))); //only 1 if ring counter is at 4
endmodule
