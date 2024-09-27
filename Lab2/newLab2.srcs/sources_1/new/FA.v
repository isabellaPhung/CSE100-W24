`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 10:05:02 AM
// Design Name: 
// Module Name: FA
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


module FA(
    input a,
    input b,
    input cin,
    output s,
    output Cout
    );
wire c1, s1, c2;
//half adder 1
assign c1 = a&b;
assign s1 = a^b;
//half adder 2
assign c2 = s1&cin;
assign s = s1^cin;
assign Cout = c1 | c2;
endmodule
