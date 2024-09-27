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


module top(
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
    output Hsync
    );
    
    wire digsel, clk;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnD), .clk(clk), .digsel(digsel));
   
    wire synchedU, synchedR, synchedL, synchedC;
FDRE #(.INIT(1'b0) ) synchU (.C(clk), .R(1'b0), .CE(~dead), .D(btnU), .Q(synchedU)); //synchronizes buttons to clock
FDRE #(.INIT(1'b0) ) synchL (.C(clk), .R(1'b0), .CE(~dead), .D(btnL), .Q(synchedL));
FDRE #(.INIT(1'b0) ) synchR (.C(clk), .R(1'b0), .CE(~dead), .D(btnR), .Q(synchedR));
FDRE #(.INIT(1'b0) ) synchC (.C(clk), .R(1'b0), .CE(~dead), .D(btnC), .Q(synchedC));
 
    wire [14:0] V, H; 
    PixelAddress grid(.clk(clk), .V(V), .H(H));

    syncs Syncs(.V(V), .H(H), .Vsync(Vsync), .Hsync(Hsync));

    wire borderOut;
    border whiteBorder(.V(V), .H(H), .borderOut(borderOut));

    wire frameSignal;
    EdgeDetector frame(.btnU(Vsync), .clk(clk), .out(frameSignal)); //edge detects Vsync for frame signal

    wire [14:0] energy;
    wire energyOut;
    //temporarily set direct input from btnC, will likely need to change this later for a synched input
    countUD15L energyCount(.CE(frameSignal & (~synchedU & (energy < 15'd192) | synchedU)), .UD(~synchedU), .LD(synchedC), .clk(clk), .Din(15'd192), .Q(energy)); //handles energy calc
    energybar bar(.btnU(synchedU), .energy(energy), .V(V), .H(H), .energyOut(energyOut)); 
    wire hover = synchedU & (energy != 0);//high if player is hovering

    //alternating frame signal for flashing
    wire alternateFrame;
    FDRE #(.INIT(1'b0) ) alternating (.C(clk), .R(1'b0), .CE(frameSignal), .D(~alternateFrame), .Q(alternateFrame));

    wire flash = (hover | dead) & alternateFrame; //only flash slug when hovering or dead

    wire slugOn;
    slug Slug(.V(V), .H(H), .slugOn(slugOn));

    wire trainMOn, trainLOn, trainROn;
    //middle train
    trainState Mtrain(.Hpos(15'd369), .start(synchedC), .clk(clk), .frame(frameSignal), .stop(dead), .trainOn(trainMOn));
    //timer for other trains to start
    wire [14:0] timer;
    count15UDL Timer(.CE(frameSignal), .UD(1'b1), .clk(clk), .Q(timer));
    //left train
    trainState Ltrain(.Hpos(15'd299), .start(timer == 15'd180), .clk(clk), .frame(frameSignal), .stop(dead), .trainOn(trainLOn));
    //right train 
    trainState Rtrain(.Hpos(15'd439), .start(timer == 15'd540), .clk(clk), .frame(frameSignal), .stop(dead), .trainOn(trainROn));

    wire dead = slugOn & (trainMOn | trainLOn | trainROn);

    assign vgaBlue = {4{slugOn & hover & flash}} | {4{borderOut}} | {4{trainMOn}} | {4{trainLOn}} | {4{trainROn}}; //slug is purple when hovering, trains are blue
    assign vgaRed = {4{slugOn & flash}} | {4{borderOut}};
    assign vgaGreen = {4{slugOn & ~hover}} | {4{energyOut}} | {4{borderOut}}; //slug is yellow when not hovering

    wire [15:0] string; //16 bit string made for selector to pick from
    assign string = 4'b0; //temp val, will change later
    assign an[3:2] = 2'b0;
    assign an[1] = ~digsel;
    assign an[0] = digsel;
    wire [3:0] select, num;
    RingCounter ring(.Advance(digsel), .clk(clk), .out(select));
    Selector selector(.sel(select), .N(string), .H(num));
    hex7seg segNum(.n(num), .leds(seg));
endmodule
