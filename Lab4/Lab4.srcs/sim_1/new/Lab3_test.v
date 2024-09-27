`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 04:32:28 PM
// Design Name: 
// Module Name: Lab3_test
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


module Lab3_test();

/*
//LED Shifter tester
reg clkin, Shift, Off, LD;
reg [15:0] Din;
wire [15:0] led;
wire lastLED;
LED_Shifter UUT(.clk(clkin), .In(Din), .Shift(Shift), .LD(LD), .Off(Off), .lastLED(lastLED), .led(led));
*/

/*
reg clkin;
wire [7:0] out;
LFSR UUT(.run(1'b1), .clk(clkin), .Q(out));
*/
/*
//State Machine testing
reg synchedC, synchedU, FourSecs, TwoSecs, Match, lastLED, clkin;
wire ShowNum, ResetTimer, RunGame, Scored, Won, FlashBoth, FlashAlt;
StateMachine UUT(
    .Go(synchedC), //inputs
    .stop(synchedU),
    .FourSecs(FourSecs), //if on, in 4 second interval
    .TwoSecs(TwoSecs), //if on, in 2 second interval
    .Match(Match),  //if 1, gameNum = randNum;
    .lastLED(lastLED), //complete win
    .clk(clkin),
    .ShowNum(ShowNum), //outputs //if on, turn on left segments
    .ResetTimer(ResetTimer), //resets time counter?
    .RunGame(RunGame),  //resets game counter after a not match
    .Scored(Scored),
    .Won(Won),
    .FlashBoth(FlashBoth),
    .FlashAlt(FlashAlt));
*/

//top testing
reg btnR, btnU, btnC, btnL, clkin;
reg [15:0] sw;
wire [3:0] an;
wire [6:0] seg;
wire[15:0] led;
wire dp;
top UUT(.clkin(clkin),
    .btnR(btnR),
    .sw(sw), //switchs for loading
    .btnU(btnU), //stop
    .btnC(btnC), //go
    .btnL(btnL), //load
    .led(led), //leds
    .an(an), //seg select
    .dp(dp), //decimal point
    .seg(seg) //segments
    );

initial    // Clock process for clkin
    begin
	clkin = 1'b1;
        forever
        begin
            #1 clkin = ~clkin;
        end
    end 
initial
begin

btnC = 1'b0;
btnU = 1'b0;
btnL = 1'b0;
sw = 16'b0;
btnR = 1'b0;
#1000;
btnC = 1'b1;
#50;
btnC = 1'b0;
#1300
btnU = 1'b1;
#50
btnU = 1'b0;
#2700
btnC = 1'b1;
sw = 16'b0111111111111111;
btnL = 1'b1;
#50
btnC = 1'b0;
btnL = 1'b0;
#2400
btnU = 1'b1;
#50
btnU = 1'b0;




/*
synchedC = 1'b0; //should be in IDLE
synchedU = 1'b0;
FourSecs = 1'b0;
TwoSecs = 1'b0;
Match = 1'b0;
lastLED = 1'b0;
#1000;
synchedC = 1'b1; //should move to TS
TwoSecs =1'b1; //NOTE will have to have two secs = 1 for game to start
#100;
synchedC = 1'b0; //should still be in TS
#100;
TwoSecs = 1'b0; //should move to GS
#300;
synchedU = 1'b1;
Match = 1'b1; //should move to M
//Match = 1'b0; //should move to NM
FourSecs = 1'b1;
#100;
Match = 1'b0;
synchedU = 1'b0;
lastLED = 1'b1;
#200;
FourSecs = 1'b0; //return to IDLE
*/
/*
//LED shifter tester
LD = 1'b0;
Shift = 1'b0;
Off = 1'b0;
Din = 16'h00FF;
#1000;
Shift = 1'b1;
#2;
Shift = 1'b0;
#100;
LD = 1'b1;
Shift = 1'b1;
#2;
LD = 1'b0;
Shift = 1'b0;
#100;
//Off = 1'b1;
Shift = 1'b1;
#2;
Shift = 1'b0;
#100;
Shift = 1'b1;
#100;
//Off = 1'b0;
Shift = 1'b0;
#100;
Shift = 1'b1;
#100;
Shift = 1'b0;
#100;
Shift = 1'b1;
#100;
Shift = 1'b0;
*/
end
endmodule
