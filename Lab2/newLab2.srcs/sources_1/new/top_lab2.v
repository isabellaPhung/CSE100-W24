`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 10:32:58 PM
// Design Name: 
// Module Name: top_lab2
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


module top_lab2(
    input [15:0] sw, //input switches
    input btnU, //sub
    input btnR, //greset
    input clkin, //clock
    output [6:0] seg, //segment display
    output dp, //overflow indicator
    output [3:0] an, //segment select
    output [15:0] led //leds
    );
wire [7:0] sum;
wire [6:0] leftOut, rightOut;
assign led = sw;
AddSub8 adder(.sub(btnU), .a(sw[15:8]), .b(sw[7:0]), .s(sum), .ovfl(dp));
hex7seg left(.n(sum[7:4]), .leds(leftOut));
hex7seg right(.n(sum[3:0]), .leds(rightOut));
wire dig_sel;
lab2_digsel clock(.clkin(clkin), .greset(btnR), .digsel(dig_sel));
multiplexer8 choose(.i0(leftOut), .i1(rightOut), .s(dig_sel), .out(seg));
assign an[0] = ~dig_sel;
assign an[1] = dig_sel;
assign an[2] = 1;
assign an[3] = 1;
endmodule
