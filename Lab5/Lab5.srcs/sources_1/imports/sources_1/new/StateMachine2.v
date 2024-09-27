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
    output Won,
    output FlashBoth,
    output FlashAlt
    );
wire [5:0] PS, NS; //6 states, past and new

wire IDLE, TS, GS, M, NM, W; //Idle, TwoSecs, GameStart, Match, NotMatch
wire nxtIDLE, nxtTS, nxtGS, nxtM, nxtNM, nxtW; //next states

assign IDLE = PS[0];
assign TS = PS[1]; //Two Second gap
assign GS = PS[2]; //Game start
assign BS = PS[3]; //Both Scored
assign LS = PS[4]; //Left Scored
assign RS = PS[5]; //Right Scored
assign BF = PS[6]; //Both Failed
assign RF = PS[7]; //Right Failed
assign LF = PS[8]; //Left Failed
assign BW = PS[9]; //Both Win
assign BL = PS[10]; //Both Lose
assign RW = PS[11]; //Right Win
assign LW = PS[12]; //Left Win

assign NS[0] = nxtIDLE;
assign NS[1] = nxtTS;
assign NS[2] = nxtGS;
assign NS[3] = nxtBS;
assign NS[4] = nxtLS;
assign NS[5] = nxtRS;
assign NS[6] = nxtBF;
assign NS[7] = nxtRF;
assign NS[8] = nxtLF;
assign NS[9] = nxtBW;
assign NS[10] = nxtBL;
assign NS[11] = nxtRW;
assign NS[12] = nxtLW;

assign nxtIDLE = (~Go)&IDLE | (~FourSecs)&BS&(~lastLED) | (~FourSecs)&LS&(~lastLED) | (~FourSecs)&RS&(~lastLED) | (~FourSecs)&BF&(~lastLED) | (~FourSecs)&RF&(~lastLED) | (~FourSecs)&LF&(~lastLED);
assign nxtTS = TwoSecs&TS | Go&IDLE;
assign nxtGS = (~TwoSecs)&TS | (~stop)&GS;
assign nxtM = stop&Match&GS | M&FourSecs;
assign nxtNM = stop&(~Match)&GS | NM&FourSecs;
assign nxtW = lastLED&M&(~FourSecs) | W;
assign ShowNum = ~IDLE;
assign ResetTimer = IDLE&Go | GS&stop;
assign RunGame = GS;
assign Scored = GS&stop&Match;
assign Won = W&lastLED&(~FourSecs);
assign FlashBoth = M;
assign FlashAlt = NM;

FDRE #(.INIT(1'b1) ) Q0_FF (.C(clk), .R(1'b0), .CE(1'b1), .D(NS[0]), .Q(PS[0]));
FDRE #(.INIT(1'b0) ) Q12_FF[12:1] (.C({12{clk}}), .R(12'b0), .CE(12'hFFF), .D(NS[12:1]), .Q(PS[12:1]));
endmodule
