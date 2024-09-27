`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 10:05:02 AM
// Design Name: 
// Module Name: AddSub8
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


module AddSub8(
    input sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output ovfl
    );
wire [7:0] c;
wire overflow1, overflow2;
assign overflow1 = ~b[0]&~b[1]&~b[2]&~b[3]&~b[4]&~b[5]&~b[6]&b[7]&sub;
assign c[0] = b[0] ^ sub;
assign c[1] = b[1] ^ sub;
assign c[2] = b[2] ^ sub;
assign c[3] = b[3] ^ sub;
assign c[4] = b[4] ^ sub;
assign c[5] = b[5] ^ sub;
assign c[6] = b[6] ^ sub;
assign c[7] = b[7] ^ sub;
Add8 adder(.A(a), .B(c), .Cin(sub), .S(s), .ovfl(overflow2));
assign ovfl = ~(overflow1 | overflow2);
endmodule
