`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 10:05:02 AM
// Design Name: 
// Module Name: hex7seg
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


module hex7seg(
    input [3:0] n,
    output [6:0] leds
    );
wire [15:0] m;
assign m[0] = ~n[3] & ~n[2]& ~n[1] & ~n[0];
assign m[1] = ~n[3] & ~n[2]& ~n[1] & n[0];
assign m[2] = ~n[3] & ~n[2]& n[1] & ~n[0];
assign m[3] = ~n[3] & ~n[2]& n[1] & n[0];
assign m[4] = ~n[3] & n[2]& ~n[1] & ~n[0];
assign m[5] = ~n[3] & n[2]& ~n[1] & n[0];
assign m[6] = ~n[3] & n[2]& n[1] & ~n[0];
assign m[7] = ~n[3] & n[2]& n[1] & n[0];
assign m[8] = n[3] & ~n[2]& ~n[1] & ~n[0];
assign m[9] = n[3] & ~n[2]& ~n[1] & n[0];
assign m[10] = n[3] & ~n[2]& n[1] & ~n[0];
assign m[11] = n[3] & ~n[2]& n[1] & n[0];
assign m[12] = n[3] & n[2]& ~n[1] & ~n[0];
assign m[13] = n[3] & n[2]& ~n[1] & n[0];
assign m[14] = n[3] & n[2]& n[1] & ~n[0];
assign m[15] = n[3] & n[2]& n[1] & n[0];
assign leds[0] = m[1] | m[4] | m[11] | m[13];
assign leds[1] = m[5] | m[6] | m[11] | m[12] | m[14] | m[15];
assign leds[2] = m[2] | m[12] | m[14] | m[15];
assign leds[3] = m[1] | m[4] | m[7] | m[9] | m[10] | m[15];
assign leds[4] = m[1] | m[3] | m[4] | m[5] | m[7] | m[9];
assign leds[5] = m[1] | m[2] | m[3] | m[7] | m[13];
assign leds[6] = m[0] | m[1] | m[7] | m[12];
endmodule
