`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2024 02:03:00 PM
// Design Name: 
// Module Name: countUD5L
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


module countUD5L(
    input UD, //up/down
    input CE, //clock edge
    input LD, //load
    input [4:0] Din, //load input
    input clk,
    output UTC,
    output DTC,
    output [4:0] Q
    );
    wire inc, dec; 
    assign inc = CE & UD; // if 1, increment
    assign dec = CE & ~UD; // if 1, decrement
    wire [4:0] D;
    wire incdec1 = inc | dec;
        
    wire xor1 = incdec1 ^ Q[0];
    wire temp = LD & Din[0] | ~LD & xor1; //if LD, D[0] = Din[0], else usual value
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .R(1'b0), .CE(CE), .D(temp), .Q(Q[0]));
    wire incTemp1 = inc & Q[0];
    wire decTemp1 = dec & ~Q[0];
    wire incdec2 = incTemp1 | decTemp1;

    wire xor2 = incdec2 ^ Q[1];
    wire temp1 = LD & Din[1] | ~LD & xor2; 
    FDRE #(.INIT(1'b0)) FF2 (.C(clk), .R(1'b0), .CE(CE), .D(temp1), .Q(Q[1]));
    wire incTemp2 = incTemp1 & Q[1];
    wire decTemp2 = decTemp1 & ~Q[1];
    wire incdec3 = incTemp2 | decTemp2;

    wire xor3 = incdec3 ^ Q[2];
    wire temp2 = LD & Din[2] | ~LD & xor3; 
    FDRE #(.INIT(1'b0)) FE3 (.C(clk), .R(1'b0), .CE(CE), .D(temp2), .Q(Q[2]));
    wire incTemp3 = incTemp2 & Q[2];
    wire decTemp3 = decTemp2 & ~Q[2];
    wire incdec4 = incTemp3 | decTemp3;

    wire xor4 = incdec4 ^ Q[3];
    wire temp3 = LD & Din[3] | ~LD & xor4; 
    FDRE #(.INIT(1'b0)) FE4 (.C(clk), .R(1'b0), .CE(CE), .D(temp3), .Q(Q[3]));
    wire incTemp4 = incTemp3 & Q[3];
    wire decTemp4 = decTemp3 & ~Q[3];
    wire incdec5 = incTemp4  | decTemp4;
    
    wire xor5 = incdec5 ^ Q[4];
    wire temp4 = LD & Din[4] | ~LD & xor5; 
    FDRE #(.INIT(1'b0)) FE5 (.C(clk), .R(1'b0), .CE(CE), .D(temp4), .Q(Q[4]));
    assign UTC = &(Q);
    assign DTC = &(~Q);
endmodule
