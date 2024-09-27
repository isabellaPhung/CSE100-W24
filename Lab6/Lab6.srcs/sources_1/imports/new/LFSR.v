`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:03:00 PM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input run,
    input clk,
    output [7:0] Q
    );
wire [7:0] rnd;
wire in;
FDRE #(.INIT(1'b1) ) one (.C(clk), .R(1'b0), .CE(run), .D(in), .Q(rnd[0]));
FDRE #(.INIT(1'b0) ) Q7_FF[6:0] (.C(clk), .R(7'b0), .CE(run), .D(rnd[6:0]), .Q(rnd[7:1]));
assign in = rnd[0] ^ rnd[5] ^ rnd[6] ^ rnd[7];
assign Q = rnd;
endmodule
