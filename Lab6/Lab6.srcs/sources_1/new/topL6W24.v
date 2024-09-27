`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 03:34:28 PM
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


module topL6W24(
//    input debugFrame,
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input [15:0] sw,
    input clkin,
    output [3:0] vgaBlue,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [6:0] seg,
    output [3:0] an,
    output Vsync,
    output Hsync,
    output [15:0] led,
    output dp
    );
    
    wire digsel, clk, dead, inMiddle;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnD), .clk(clk), .digsel(digsel));

   wire synchedU, synchedR, synchedL, synchedC, gameStarted;
FDRE #(.INIT(1'b0) ) synchU (.C(clk), .R(1'b0), .CE(~dead & inMiddle & gameStarted), .D(btnU), .Q(synchedU)); //synchronizes buttons to clock
FDRE #(.INIT(1'b0) ) synchL (.C(clk), .R(1'b0), .CE(~dead & gameStarted), .D(btnL), .Q(synchedL));
FDRE #(.INIT(1'b0) ) synchR (.C(clk), .R(1'b0), .CE(~dead & gameStarted), .D(btnR), .Q(synchedR));
FDRE #(.INIT(1'b0) ) synchC (.C(clk), .R(1'b0), .CE(~dead), .D(btnC), .Q(synchedC)); 
FDRE #(.INIT(1'b0) ) gameStart (.C(clk), .R(1'b0), .CE(synchedC), .D(1'b1), .Q(gameStarted)); 

    wire [14:0] V, H; 
    PixelAddress grid(.clk(clk), .V(V), .H(H));

    wire tempVsync, tempHsync;
    syncs Syncs(.V(V), .H(H), .Vsync(tempVsync), .Hsync(tempHsync));
    FDRE #(.INIT(1'b0) ) VSync (.C(clk), .R(1'b0), .CE(1'b1), .D(tempVsync), .Q(Vsync)); //syncs outputs to clk
    FDRE #(.INIT(1'b0) ) HSync (.C(clk), .R(1'b0), .CE(1'b1), .D(tempHsync), .Q(Hsync));


    wire borderOut;
    border whiteBorder(.V(V), .H(H), .borderOut(borderOut));

    wire frameSignal;
//    assign frameSignal = debugFrame; //only used for debugging
    EdgeDetector frame(.btnU(Vsync), .clk(clk), .out(frameSignal)); //edge detects Vsync for frame signal

    wire [14:0] energy;
    wire energyOut;
    //temporarily set direct input from btnC, will likely need to change this later for a synched input
    countUD15L energyCount(.CE(frameSignal & (~synchedU & (energy <= 15'd192) | (synchedU & (energy > 15'b0)))), .UD(~synchedU), .LD(synchedC), .clk(clk), .Din(15'd192), .Q(energy)); //handles energy calc
    energybar bar(.energy(energy), .V(V), .H(H), .energyOut(energyOut)); 
    wire hover = synchedU & (energy != 0);//high if player is hovering

    //alternating frame signal for flashing
    wire alternating;
    wire [14:0] count;
    countUD15L alternateCount(.Din(15'h01E), .LD(count == 0), .CE(frameSignal), .UD(1'b0), .clk(clk), .Q(count));
    FDRE #(.INIT(1'b0) ) Alternating (.C(clk), .R(count == 15'h01E), .CE(~|(count ^ 15'h0F)), .D(1'b1), .Q(alternating));

    wire flash = (hover | dead) & alternating; //only flash slug when hovering or dead

    wire slugOn;
    wire [3:0] tempvgaBlue, tempvgaRed, tempvgaGreen;
    slug Slug(.V(V), .H(H), .frame(frameSignal), .btnL(synchedL), .btnR(synchedR), .clk(clk), .inMiddle(inMiddle), .slugOn(slugOn));

    wire trainMOn, trainLOn, trainROn, Mpoint, Lpoint, Rpoint;
    wire [15:0] timer;
    countUD15L Timer(.CE(frameSignal & gameStarted), .LD(synchedC), .Din(16'b0), .UD(1'b1), .clk(clk), .Q(timer));
    
    //left train
    //trainState Ltrain(.H(H), .V(V), .Hpos(15'd299), .frontPos(15'd400), .start(synchedC & ~gameStarted), .clk(clk), .frameIn(frameSignal), .stop(dead), .point(Lpoint), .trainOn(trainLOn));
    //right train 
    //trainState Rtrain(.H(H), .V(V), .Hpos(15'd439), .frontPos(15'd400), .start((timer == 15'd120) & gameStarted), .clk(clk), .frame(frameSignal), .stop(dead), .point(Rpoint), .trainOn(trainROn));
    //middle train
    //trainState Mtrain(.H(H), .V(V), .Hpos(15'd369), .frontPos(15'd440), .start((timer == 15'd480) & gameStarted), .clk(clk), .frame(frameSignal), .stop(dead), .point(Mpoint), .trainOn(trainMOn));
    //timer for other trains to start

    
    assign dead = (~sw[3] | ~hover) & (slugOn & (trainMOn | trainLOn | trainROn));
    
    wire [14:0] points;
    wire Medge, Ledge, Redge;
    EdgeDetector MpointEdge(.btnU(Mpoint), .clk(clk), .out(Medge)); //edge detects Vsync for frame signal
    EdgeDetector LpointEdge(.btnU(Lpoint), .clk(clk), .out(Ledge)); //edge detects Vsync for frame signal
    EdgeDetector RpointEdge(.btnU(Rpoint), .clk(clk), .out(Redge)); //edge detects Vsync for frame signal

    countUD15L pointCount(.CE(Medge | Ledge | Redge), .LD(synchedC), .Din(16'b0), .UD(1'b1), .clk(clk), .Q(points)); //counts points

    assign tempvgaBlue = {4{slugOn & (hover & flash)}} | {4{borderOut}} | {4{trainMOn}} | {4{trainLOn}} | {4{trainROn}}; //slug is purple when hovering
    assign tempvgaRed = {4{(slugOn & ~hover) | (slugOn & hover & flash) | (slugOn & dead & flash)}} | {4{borderOut}};
    assign tempvgaGreen = {4{(slugOn & ~hover) | (slugOn & dead & flash)}} | {4{energyOut}} | {4{borderOut}}; //slug is yellow when not hovering
    FDRE #(.INIT(1'b0) ) VGABlue [3:0] (.C({4{clk}}), .R(4'b0), .CE(4'hF), .D(tempvgaBlue), .Q(vgaBlue)); //syncs outputs to clk
    FDRE #(.INIT(1'b0) ) VGARed [3:0] (.C({4{clk}}), .R(4'b0), .CE(4'hF), .D(tempvgaRed), .Q(vgaRed)); //syncs outputs to clk
    FDRE #(.INIT(1'b0) ) VGAGreen [3:0] (.C({4{clk}}), .R(4'b0), .CE(4'hF), .D(tempvgaGreen), .Q(vgaGreen)); //syncs outputs to clk


    wire [15:0] string; //16 bit string made for selector to pick from
    assign string = points;
    wire [3:0] select, num;
    RingCounter ring(.Advance(digsel), .clk(clk), .out(select));
    Selector selector(.sel(select), .N(string), .H(num));
    hex7seg segNum(.n(num), .leds(seg));
    assign an[3:2] = 2'b11;
    assign an[1] = ~(select == 4'b0010);
    assign an[0] = ~(select == 4'b0001);
    assign led = 16'b0;
    assign dp = 1'b1;
    assign led[16] = gameStarted;
    assign led[15] = dead;
    
endmodule
