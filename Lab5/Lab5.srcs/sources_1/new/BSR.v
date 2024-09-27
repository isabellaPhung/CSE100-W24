`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2024 01:40:58 AM
// Design Name: 
// Module Name: BSR
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


module BSR(
    input rightLeft,
    input CE,
    output [5:0] out,
    input clk
    );
    wire [5:0] Q;
    FDRE #(.INIT(1'b0) ) startPoints [2:0] (.C({3{clk}}), .R(3'b0), .CE({3{CE}}), .D(({3{rightLeft}} & Q[3:1]) | ({3{~rightLeft}} & {Q[1:0], rightLeft})), .Q(Q[2:0])); 
    FDRE #(.INIT(1'b1) ) points [2:0] (.C({3{clk}}), .R(3'b0), .CE({3{CE}}), .D(({3{rightLeft}} & {rightLeft, Q[5:4]}) | ({3{~rightLeft}} & Q[4:2])), .Q(Q[5:3])); 

    assign out = Q;

endmodule
