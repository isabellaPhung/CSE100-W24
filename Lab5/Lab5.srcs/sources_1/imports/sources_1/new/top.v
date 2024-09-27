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
    input btnR, //right player
    input [15:0] sw, //switchs for loading
    input btnU, //reset
    input btnC, //go
    input btnL, //left player
    output [15:0] led, //leds
    output [3:0] an, //seg select
    output dp, //decimal point
    output [6:0] seg //segments
    );
wire FourSecs, TwoSecs, Match, lastLED, ShowNum, ResetTimer, RunGame, Scored, End, FlashBoth, FlashAlt;

wire clk, digsel, qsec;
qsec_clks clock(.clkin(clkin), .greset(btnU), .clk(clk), .digsel(digsel), .qsec(qsec)); //slowed clock

wire tempSynchedR, synchedC, synchedL;
EdgeDetector synchR(.btnU(RunGame & btnR), .clk(clk), .out(tempSynchedR));
EdgeDetector synchL(.btnU(RunGame & btnL), .clk(clk), .out(synchedL));
EdgeDetector synchC(.btnU(~End & btnC), .clk(clk), .out(synchedC));

wire synchedR = (sw[15] & synchedL) | (~sw[15] & tempSynchedR); //synchs inputs L and R if sw[15] on

wire stop = synchedL | synchedR;

StateMachine stopIt(
    .Go(synchedC), //inputs
    .stop(stop),
    .FourSecs(FourSecs), //if on, in 4 second interval
    .TwoSecs(TwoSecs), //if on, in 2 second interval
    .Match(Match),  //if 1, gameNum == randNum;
    .lastLED(lastLED), //game end condition
    .clk(clk),
    .ShowNum(ShowNum), //outputs //if on, turn on left segments
    .ResetTimer(ResetTimer), //resets time counter
    .RunGame(RunGame),  //only runs during Game Start
    .Scored(Scored), //on if player has won a round
    .End(End), //on if game over
    .FlashBoth(FlashBoth),
    .FlashAlt(FlashAlt));

wire [4:0] randNum;
LFSR random(.run(synchedC & (~End)), .clk(clk), .Q(randNum)); //random num generator, set to run on synched C so it runs only for 1 clock

wire alternateQsec;
FDRE #(.INIT(1'b0) ) alternating (.C(clk), .R(1'b0), .CE(qsec), .D(~alternateQsec), .Q(alternateQsec)); //high until next q sec for flashing lights

wire dsec; //for slowing game down to half a second
dsec doubleSec(.qsec(qsec), .clk(clk), .dsec(dsec));

//LEDs
wire [5:0] leftScore, rightScore, flipped;
BSR LeftScore(.rightLeft(Scored), .CE(stop & synchedL), .clk(clk), .out(leftScore)); //activates left LEDS
BSR RightScore(.rightLeft(Scored), .CE(stop & synchedR), .clk(clk), .out(rightScore)); //activates right LEDS

wire BF = ~rightScore[5] & ~leftScore[5]; //both fail
wire RW = ~BF & (rightScore[0] | ~leftScore[5]); //right win
wire LW = ~BF & (leftScore[0] | ~rightScore[5]); //left win
assign lastLED = RW | LW | BF;

assign flipped[0] = rightScore[5];
assign flipped[1] = rightScore[4];
assign flipped[2] = rightScore[3];
assign flipped[3] = rightScore[2];
assign flipped[4] = rightScore[1];
assign flipped[5] = rightScore[0];

//assign led[5:0] = flippedRight;
//assign led[15:10] = leftScore;
assign led[5:0] = ({6{~RW}} & flipped) | ({6{RW & alternateQsec}} & flipped); //flashes right LEDs after winning
assign led[15:10] = ({6{~LW}} & leftScore) | ({6{LW & alternateQsec}} & leftScore); //flashes left LEDs after winning

//game match check
//checks sw[14] to see if it should run on dsec or qsec time
wire [4:0] gameNum;
Game_Counter gameCount(.CE((RunGame & qsec & ~sw[14]) | (sw[14] & dsec & RunGame)), .R(synchedC), .Q(gameNum), .clk(clk)); //decrementer user has to stop
assign Match = stop & &(~(randNum ^ gameNum)); //checks for match

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
 
//flashing seg
//if not showNum, dont show an[3:2]. if ShowNum and neither FlashAlt or FlashBoth are on, use select
//if ShowNum and Flashboth is on, AND  with qsec. if ShowNum and FlashAlt is on, AND with ~qsec
assign an[3:2] = ~(({2{~ShowNum}} & 2'b0) | ({2{ShowNum}}  & ((select[3:2] & ~({2{FlashAlt}} | {2{FlashBoth}})) | ({2{FlashBoth}} & select[3:2] & {2{alternateQsec}}) | ({2{FlashAlt}} & select[3:2] & {2{~alternateQsec}}))));
//always on regardless of showNum. if neither FlashAlt or FlashBoth, use select, if either FlashAlt or Flashboth, AND with qsec
assign an[1:0] = ~(((select[1:0] & ~({2{FlashAlt}} | {2{FlashBoth}}))) | (({2{FlashBoth}} | {2{FlashAlt}}) & select[1:0] & {2{alternateQsec}}));
assign dp = ~(BF & ~FourSecs & alternateQsec); //if both lose, flash dp

endmodule
