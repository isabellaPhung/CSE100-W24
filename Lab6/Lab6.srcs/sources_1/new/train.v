`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 03:34:28 PM
// Design Name: 
// Module Name: train
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

//391 for center track
//299 for left
//439 for right
//each track 60 px wide
module train(
    input [15:0] offset, //for if train is to positioned elsewhere, default is 391 for the center track
    input frontPos, //position where front signals 2nd train to start
    input start, //cue for train to start
    input clk,
    input stop, //stop everything when slug is dead
    input frame,
    output trainOn
    );

wire generate, resetTimer;

LSFR(.run(generate), .clk(clk), .output(rnd)); //random num
FDRE #(.INIT(1'b0) ) RndLength (.C(clk), .R(1'b0), .CE(qsec), .D(rnd), .Q(alternateQsec));

trainState stateMachine(.start(start), .rndLength1(), rndLength2(), .rndTime1(), .rndTime2(), .front1(), .front2(), .frontPos(), .timer(), .generate(generate) , .resetTimer(resetTimer));

    wire ending = position == frontPos; //if position at frontPosition, the front train is ending;
    //
    wire generate = start | ending | rndLength == 0 | rndTime == 0;
    wire [7:0] rnd;
    LSFR(.run(generate), .clk(clk), .output(rnd)); //random num
    wire rndLength = ((rnd < 63) & rnd);
    wire rndTime = ((rnd < 127 & rnd > 1) & rnd);
    count15UDL timer(.CE(), .UD(), .LD(), .clk(clk), Din(), .Q(slugLocation)); 

assign trainOn = H > (15'd391 + offset) & H < (15'd391 + 15'd60 + offset)
endmodule
