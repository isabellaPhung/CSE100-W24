`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2024 12:46:53 PM
// Design Name: 
// Module Name: FallingEdgeD
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


module FallingEdgeD(
    input in,
    input clk,
    output out
    );
    wire b, c;
    FDRE #(.INIT(1'b0)) one (.C(clk),  .R(1'b0), .CE(1'b1), .D(in), .Q(b));
    FDRE #(.INIT(1'b0)) two (.C(clk),  .R(1'b0), .CE(1'b1), .D(b), .Q(c));
    assign out = ~b&c;
endmodule
