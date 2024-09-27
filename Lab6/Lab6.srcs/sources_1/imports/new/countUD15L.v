`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2024 02:03:00 PM
// Design Name: 
// Module Name: countUD15L
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


module countUD15L(
    input CE, //clock edge
    input UD, //up/down, 1 when incrementing, 0 when decrementing
    input LD, //load
    input clk,
    input [15:1] Din, //input
    output UTC, //for resetting 15 to 0 when incrementing
    output DTC, //for resetting 0 to 15 when decrementing
    output [15:0] Q //output 
    );
    wire CEE;
    //EdgeDetector synch(.btnU(CE), .clk(clk), .out(CEE)); //edge detects Vsync for frame signal
    FDRE #(.INIT(1'b0) ) synchCE (.C(clk), .R(1'b0), .CE(1'b1), .D(CE), .Q(CEE));


    wire inc, dec;
    assign inc = CEE & UD; // if 1, increment
    assign dec = CEE & ~UD; // if 1, decrement

    wire [2:0] UTCtemp, DTCtemp;

    countUD5L one(.UD(UD), .CE(CEE), .LD(LD) ,.clk(clk), .Din(Din[5:1]), .DTC(DTCtemp[0]), .UTC(UTCtemp[0]), .Q(Q[4:0]));
    wire incTemp1 = inc & UTCtemp[0];
    wire decTemp1 = dec & DTCtemp[0];
    wire CE2 = LD | incTemp1 | decTemp1;

    countUD5L two(.UD(UD), .CE(CE2), .LD(LD), .clk(clk), .Din(Din[10:6]), .DTC(DTCtemp[1]), .UTC(UTCtemp[1]), .Q(Q[9:5]));
    wire incTemp2 = incTemp1 & UTCtemp[1];
    wire decTemp2 = decTemp1 & DTCtemp[1];
    wire CE3 = LD | incTemp2 | decTemp2;
    
    countUD5L three(.UD(UD), .CE(CE3), .LD(LD), .clk(clk), .Din(Din[15:11]), .DTC(DTCtemp[2]), .UTC(UTCtemp[2]), .Q(Q[14:10]));

    assign UTC = &(UTCtemp);
    assign DTC = &(DTCtemp);
    assign Q[15] = 0;
endmodule
