`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:03:00 PM
// Design Name: 
// Module Name: LED_Shifter
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

//controls LEDs for number of games won
//off = 1 until first game one
//like a johnson counter
module LED_Shifter(
    input [15:0] In,
    input LD,
    input Shift,
    input Off, //turns off all LEDs
    input clk,
    output lastLED,
    output [15:0] led
    );

wire [16:0] Q;
//FDRE #(.INIT(1'b0) ) Q16_FF[15:0] (.C({16{clk}}), .R(16'b0), .CE({16{Shift}}), .D({Q[14:0], Shift}), .Q(Q));
FDRE #(.INIT(1'b0) ) Q16_FF[16:0] (.C({17{clk}}), .R(17'b0), .CE({17{Shift | LD}}), .D(({17{~LD}} & {Q[15:0], Shift}) | ({17{LD}} & In)), .Q(Q));
assign lastLED = Q[16];

assign led =  {16{Off}} & 16'b0 | {16{~Off}} & Q[15:0]; // if Off, led = 0, else led = temp


endmodule
