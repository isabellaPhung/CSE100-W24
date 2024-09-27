`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:03:00 PM
// Design Name: 
// Module Name: StateMachine
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


module StateMachine(
    input Go,
    input stop,
    input FourSecs,
    input TwoSecs,
    input Match,
    input lastLED,
    input clk,
    output ShowNum,
    output ResetTimer,
    output RunGame,
    output Scored,
    output End,
    output FlashBoth,
    output FlashAlt
    );
wire [5:0] PS, NS; //6 states, past and new

wire IDLE, TS, GS, M, NM, W; //Idle, TwoSecs, GameStart, Match, NotMatch
wire nxtIDLE, nxtTS, nxtGS, nxtM, nxtNM, nxtW; //next states

assign IDLE = PS[0];
assign TS = PS[1];
assign GS = PS[2];
assign M = PS[3];
assign NM = PS[4];
assign W = PS[5];

assign NS[0] = nxtIDLE;
assign NS[1] = nxtTS;
assign NS[2] = nxtGS;
assign NS[3] = nxtM;
assign NS[4] = nxtNM;
assign NS[5] = nxtW;

assign nxtIDLE = (~Go)&IDLE | (~FourSecs)&NM&(~lastLED) | (~FourSecs)&M&(~lastLED);
assign nxtTS = TwoSecs&TS | Go&IDLE;
assign nxtGS = (~TwoSecs)&TS | (~stop)&GS;
assign nxtM = stop&Match&GS | M&FourSecs;
assign nxtNM = stop&(~Match)&GS | NM&FourSecs;
assign nxtW = lastLED&M&(~FourSecs) | W;
assign ShowNum = ~IDLE;
assign ResetTimer = IDLE&Go | GS&stop;
assign RunGame = GS;
assign Scored = GS&stop&Match;
assign End = W&lastLED&(~FourSecs);
assign FlashBoth = M;
assign FlashAlt = NM;

FDRE #(.INIT(1'b1) ) Q0_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[0]), .Q(PS[0]));
FDRE #(.INIT(1'b0) ) Q1_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[1]), .Q(PS[1]));
FDRE #(.INIT(1'b0) ) Q2_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[2]), .Q(PS[2]));
FDRE #(.INIT(1'b0) ) Q3_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[3]), .Q(PS[3]));
FDRE #(.INIT(1'b0) ) Q4_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[4]), .Q(PS[4]));
FDRE #(.INIT(1'b0) ) Q5_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[5]), .Q(PS[5]));
FDRE #(.INIT(1'b0) ) Q6_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[6]), .Q(PS[6]));
//for some reason doing the bus did not work and caused errors, something with NS and PS not lining up maybe
//FDRE #(.INIT(1'b0) ) Q5_FF[4:0] (.C({5{clk}}), .R(5'b0), .CE(5'b1), .D(NS[5:1]), .Q(PS[5:1]));
endmodule
