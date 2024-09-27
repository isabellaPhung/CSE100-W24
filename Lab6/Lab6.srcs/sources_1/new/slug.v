`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 03:34:28 PM
// Design Name: 
// Module Name: slug
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


module slug(
    input [14:0] V, //width
    input [14:0] H, //height
    input frame,
    input btnL,
    input btnR,
    input clk,
    output inMiddle,
    output slugOn
    );
    //for now stays in place, centered at px 400
    //16px by 16px
    //left edge 391, right edge 407, top edge 360, bottom edge 376
    //1 when V in range 391-407, H in range 360-376
    //these the V values will shift up or down by 1 frame depending on the button press

wire sliding;
assign sliding = slidingRFM | slidingLFM | slidingLFR | slidingRFL;
wire leftRight = (slidingRFM | slidingRFL);
wire [14:0] slugLocation;
countUD15L SlugLocation(.CE((frame & sliding & (slugLocation >= 15'd321 & slugLocation <= 15'd461)) | (slugLocation < 15'd321 | slugLocation > 15'd461)), .UD(leftRight), .LD(slugLocation < 15'd321 | slugLocation > 15'd461), .clk(clk), .Din(15'b0110000111), .Q(slugLocation));

wire M, L, R, slidingRFM, slidingLFM, slidingLFR, slidingRFL;
wire NxtM, NxtL, NxtR, NxtslidingRFM, NxtslidingLFM, NxtslidingLFR, NxtslidingRFL;
wire [6:0] PS, NS;

FDRE #(.INIT(1'b1)) Q0_FF (.C(clk),.R(1'b0),.CE(1'b1),.D(NS[0]),.Q(PS[0]));
FDRE #(.INIT(1'b0)) Q6_FF[6:1] (.C({6{clk}}),.R(6'b0),.CE(6'h3F),.D(NS[6:1]),.Q(PS[6:1]));

assign M = PS[0];
assign L = PS[1]; 
assign R = PS[2]; 
assign slidingRFM = PS[3]; 
assign slidingLFM = PS[4];
assign slidingLFR = PS[5];
assign slidingRFL = PS[6];

assign NS[0] = NxtM;
assign NS[1] = NxtL;
assign NS[2] = NxtR;
assign NS[3] = NxtslidingRFM;
assign NS[4] = NxtslidingLFM;
assign NS[5] = NxtslidingLFR;
assign NS[6] = NxtslidingRFL;

assign NxtM = (M & (~btnL & ~btnR)) | (slidingRFL & (slugLocation == 15'd391)) | (slidingLFR & (slugLocation == 15'd391));
assign NxtL = (L & ~btnR) | (slidingLFM & (slugLocation == 15'd321));
assign NxtR = (R & ~btnL) |(slidingRFM & (slugLocation == 15'd461));
assign NxtslidingRFM = (M & btnR) | (slidingLFR & btnR) | (slidingRFM & ~btnL & slugLocation != 15'd461);
assign NxtslidingLFM = (M & btnL) | (slidingRFL & btnL) | (slidingLFM & ~btnR & slugLocation != 15'd321);
assign NxtslidingLFR = (R & btnL) | (slidingRFM & btnL) | (slidingLFR & ~btnR & slugLocation != 15'd391);
assign NxtslidingRFL = (L & btnR) | (slidingLFM & btnR) | (slidingRFL & ~btnL & slugLocation != 15'd391);
    assign inMiddle = M;
    assign slugOn = H > slugLocation & H < (slugLocation + 15'd16) & V > 15'd360 & V < 15'd376;
endmodule
