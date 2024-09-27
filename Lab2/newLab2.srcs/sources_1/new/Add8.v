`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 10:06:03 AM
// Design Name: 
// Module Name: Add8
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


module Add8(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output ovfl,
    output Cout
    );
wire [6:0] carryOut;
FA one(.a(A[0]), .b(B[0]), .cin(Cin), .s(S[0]), .Cout(carryOut[0]));
FA two(.a(A[1]), .b(B[1]), .cin(carryOut[0]), .s(S[1]), .Cout(carryOut[1]));
FA three(.a(A[2]), .b(B[2]), .cin(carryOut[1]), .s(S[2]), .Cout(carryOut[2]));
FA four(.a(A[3]), .b(B[3]), .cin(carryOut[2]), .s(S[3]), .Cout(carryOut[3]));
FA five(.a(A[4]), .b(B[4]), .cin(carryOut[3]), .s(S[4]), .Cout(carryOut[4]));
FA six(.a(A[5]), .b(B[5]), .cin(carryOut[4]), .s(S[5]), .Cout(carryOut[5]));
FA seven(.a(A[6]), .b(B[6]), .cin(carryOut[5]), .s(S[6]), .Cout(carryOut[6]));
FA eight(.a(A[7]), .b(B[7]), .cin(carryOut[6]), .s(S[7]), .Cout(Cout));
assign ovfl = ~A[7]&~B[7]&S[7] | A[7]&B[7]&~S[7];
endmodule
