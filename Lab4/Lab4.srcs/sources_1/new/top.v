`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:03:00 PM
// Design Name: 
// Module Name: top
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


module top(
    input clkin,
    input btnR,
    input [15:0] sw, //switchs for loading
    input btnU, //stop
    input btnC, //go
    input btnL, //load
    output [15:0] led, //leds
    output [3:0] an, //seg select
    output dp, //decimal point
    output [6:0] seg //segments
    );
wire FourSecs, TwoSecs, Match, lastLED, ShowNum, ResetTimer, RunGame, Scored, Won, FlashBoth, FlashAlt;

wire clk, digsel, qsec;
qsec_clks clock(.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel), .qsec(qsec)); //slowed clock

wire synchedU, synchedC, synchedL;
FDRE #(.INIT(1'b0) ) synchU (.C(clk), .R(1'b0), .CE(~Won), .D(btnU), .Q(synchedU)); //synchronizes buttons to clock
FDRE #(.INIT(1'b0) ) synchL (.C(clk), .R(1'b0), .CE(~Won), .D(btnL), .Q(synchedL));
FDRE #(.INIT(1'b0) ) synchC (.C(clk), .R(1'b0), .CE(~Won), .D(btnC), .Q(synchedC));

StateMachine stopIt(
    .Go(synchedC), //inputs
    .stop(synchedU),
    .FourSecs(FourSecs), //if on, in 4 second interval
    .TwoSecs(TwoSecs), //if on, in 2 second interval
    .Match(Match),  //if 1, gameNum == randNum;
    .lastLED(lastLED), //complete win
    .clk(clk),
    .ShowNum(ShowNum), //outputs //if on, turn on left segments
    .ResetTimer(ResetTimer), //resets time counter
    .RunGame(RunGame),  //only runs during Game Start
    .Scored(Scored), //on if player has won a round
    .Won(Won), //on if player has won entire game (16 rounds)
    .FlashBoth(FlashBoth),
    .FlashAlt(FlashAlt));

wire [4:0] randNum;
LFSR random(.run(synchedC), .clk(clk), .Q(randNum)); //random num generator, set to run on synched C so it runs only for 1 clock

wire alternateQsec;
FDRE #(.INIT(1'b0) ) alternating (.C(clk), .R(1'b0), .CE(qsec), .D(~alternateQsec), .Q(alternateQsec));
//LEDs
wire [15:0] tempLED;
//OffSwitch = if on, leds are off and user hasn't won a match
//turns on once user has won 1 match
LED_Shifter shifter(.In(sw), .LD(synchedL), .Shift(Scored), .Off(1'b0), .clk(clk), .lastLED(lastLED), .led(tempLED)); //activates next LED
assign led = ({16{~Won}} & tempLED) | {16{Won & alternateQsec}};
//assign led = ~({16{~(Won & alternateQsec)}} | ({16{~Won}} & tempLED)); //if Won is on, LEDs flash, otherwise follow shifter output

//game match check
//using synchC as r for game counter but i don' tthink it'll work
wire [4:0] gameNum;
Game_Counter gameCount(.CE(RunGame & qsec), .R(synchedC), .Q(gameNum), .clk(clk)); //decrementer user has to stop
assign Match = synchedU & &(~(randNum ^ gameNum)); //checks for match

//timer
wire [4:0] timeNum;
Time_Counter timeCount(.CE(qsec), .R(ResetTimer), .Q(timeNum), .clk(clk)); //incrementer for time, always running
FDRE #(.INIT(1'b0) ) twoInterval (.C(clk), .R(~|(timeNum ^ 5'b01000)), .CE(ResetTimer), .D(1'b1), .Q(TwoSecs)); //starts at 0, ResetTimer sets to 1, resets to 0 if timeNum = 8
FDRE #(.INIT(1'b0) ) fourInterval (.C(clk), .R(~|(timeNum ^ 5'b10000)), .CE(ResetTimer), .D(1'b1), .Q(FourSecs)); //starts at 0, ResetTimer sets to 1, resets to 0 if timeNum = 16

//need to create a string of numbers 16 bits long for selecter to pick
wire [15:0] string;
assign string[15:8] = randNum;
assign string[7:0] = gameNum;
//selecting seg display
wire [3:0] select, num;
RingCounter ring(.Advance(digsel), .clk(clk), .out(select));
Selector selector(.sel(select), .N(string), .H(num));
hex7seg segNum(.n(num), .leds(seg));
assign dp = 1;
// | ({2{ShowNum}}  & ((~select[3:2] & ~({2{FlashAlt}} | {2{FlashBoth}})) | ({2{FlashBoth}} & ~select[3:2] & {2{qsec}}) | ({2{FlashAlt}} & ~select[3:2] & {2{~qsec}})))
//flashing seg
//if not showNum, dont show an[3:2]. if ShowNum and neither FlashAlt or FlashBoth are on, use select
//if ShowNum and Flashboth is on, AND  with qsec. if ShowNum and FlashAlt is on, AND with ~qsec

assign an[3:2] = ~(({2{~ShowNum}} & 2'b0) | ({2{ShowNum}}  & ((select[3:2] & ~({2{FlashAlt}} | {2{FlashBoth}})) | ({2{FlashBoth}} & select[3:2] & {2{alternateQsec}}) | ({2{FlashAlt}} & select[3:2] & {2{~alternateQsec}}))));
//always on regardless of showNum. if neither FlashAlt or FlashBoth, use select, if either FlashAlt or Flashboth, AND with qsec
assign an[1:0] = ~(((select[1:0] & ~({2{FlashAlt}} | {2{FlashBoth}}))) | (({2{FlashBoth}} | {2{FlashAlt}}) & select[1:0] & {2{alternateQsec}}));

endmodule
