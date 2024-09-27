`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2024 02:03:00 PM
// Design Name: 
// Module Name: RingCounter
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


module RingCounter(
    input Advance,
    input clk,
    output [3:0] out
    );
    wire [3:0] D;
    //wire temp0, temp3;
    //assign temp3 = ~out[3];
    wire temp;
    FDRE #(.INIT(1'b0)) one (.C(clk), .R(1'b0), .CE(Advance), .D(D[0]), .Q(temp));
    assign out[0] = ~temp;
    //assign out[0] = temp0;
    FDRE #(.INIT(1'b0)) two (.C(clk), .R(1'b0), .CE(Advance), .D(D[1]), .Q(out[1]));
    FDRE #(.INIT(1'b0)) three (.C(clk), .R(1'b0), .CE(Advance), .D(D[2]), .Q(out[2]));
    FDRE #(.INIT(1'b0)) four (.C(clk), .R(1'b0), .CE(Advance), .D(D[3]), .Q(out[3]));
    assign D[0] = ~out[3];
    assign D[1] = out[0];
    assign D[2] = out[1];
    assign D[3] = out[2];
endmodule
