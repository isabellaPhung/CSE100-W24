`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 04:29:14 PM
// Design Name: 
// Module Name: trainState
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


module trainState(
    input [14:0] H,
    input [14:0] V,
    input [14:0] Hpos,
    input [14:0] frontPos,
    input start,
    input clk,
    input frameIn,
    input stop, //stop everything when slug is dead
    output point,
    output trainOn
    //output debug,
//    output [15:0] timer
    );
    wire frame;
    EdgeDetector synch(.btnU(frameIn), .clk(clk), .out(frame)); //edge detects Vsync for frame signal

wire [8:0] PS, NS;
FDRE #(.INIT(1'b1)) Q0_FF (.C(clk),.R(1'b0),.CE(1'b1),.D(NS[0]),.Q(PS[0]));
FDRE #(.INIT(1'b0)) Q8_FF[8:1] (.C({8{clk}}),.R(8'b0),.CE(8'hFF),.D(NS[8:1]),.Q(PS[8:1]));

wire IDLE, genTime1, genLength1, Train1Wait, Train1Des, genTime2, genLength2, Train2Wait, Train2Des;
wire nxtIDLE, nxtgenTime1, nxtgenLength1, nxtTrain1Wait, nxtTrain1Des, nxtgenTime2, nxtgenLength2, nxtTrain2Wait, nxtTrain2Des;

assign IDLE = PS[0];
assign genTime1 = PS[1];
assign genLength1 = PS[2];
assign Train1Wait = PS[3];
assign Train1Des = PS[4];
assign genTime2 = PS[5];
assign genLength2 = PS[6];
assign Train2Wait = PS[7];
assign Train2Des = PS[8];

assign NS[0] = nxtIDLE;
assign NS[1] = nxtgenTime1;
assign NS[2] = nxtgenLength1;
assign NS[3] = nxtTrain1Wait;
assign NS[4] = nxtTrain1Des;
assign NS[5] = nxtgenTime2;
assign NS[6] = nxtgenLength2;
assign NS[7] = nxtTrain2Wait;
assign NS[8] = nxtTrain2Des;

wire [15:0] front1, front2, tempfront1, tempfront2, train1Back, train2Back;
wire newRnd, resetTimer, start1, start2;
wire [15:0] timer;
countUD15L Timer(.CE(frame | resetTimer), .UD(1'b1), .LD(resetTimer), .clk(clk), .Din(16'b0), .Q(timer));
wire [7:0] rndTime1, rndTime2, rndLength1, rndLength2;

wire [7:0] rnd;
assign nxtIDLE = IDLE & ~start;
assign nxtgenTime1 = (genTime1 & ((rnd <= 8'd1) | (rnd >= 8'd127))) | (Train2Des & front2 == frontPos) | (IDLE & start);
assign nxtgenLength1 = (genTime1 & (rnd > 8'd1) & (rnd < 8'd127)) | (genLength1 & (rnd >= 8'd63));
assign nxtTrain1Wait = (genLength1 & (rndLength1 < 8'd63)) | (Train1Wait & timer != rndTime1);
assign nxtTrain1Des = (Train1Wait & (timer == rndTime1)) | (Train1Des & (front1 != frontPos));
assign nxtgenTime2 =  (genTime2 & ((rnd <= 8'd1) | (rnd >= 8'd127))) | (Train1Des & front1 == frontPos); 
assign nxtgenLength2 = (genTime2 & (rnd > 8'd1) & (rnd < 8'd127)) | (genLength2 & (rnd >= 8'd63));
assign nxtTrain2Wait = (genLength2 & (rndLength2 < 8'd63)) | (Train2Wait & timer != rndTime2);
assign nxtTrain2Des =  (Train2Wait & (timer == rndTime2)) | (Train2Des & (front2 != frontPos));

assign newRnd = nxtgenTime1 | nxtgenTime2 | nxtgenLength1 | nxtgenLength2;
assign resetTimer = newRnd | ((genLength1 & (rndLength1 < 8'd63)) | (genLength2 & (rndLength2 < 8'd63)));
assign start1 = nxtTrain1Wait & (timer == rndTime1-(1'b1)) | (Train1Wait & (timer == rndTime1));
assign start2 = nxtTrain2Wait & (timer == rndTime2-(1'b1)) | Train2Wait & (timer == rndTime2);

LFSR randNum(.run(newRnd), .clk(clk), .Q(rnd)); //random num
FDRE #(.INIT(1'b0) ) RndTime1[7:0] (.C(clk), .R(1'b0), .CE(genTime1), .D(rnd), .Q(rndTime1));
FDRE #(.INIT(1'b0) ) RndLength1[7:0] (.C(clk), .R(1'b0), .CE(genLength1), .D(rnd), .Q(rndLength1));
FDRE #(.INIT(1'b0) ) RndTime2[7:0] (.C(clk), .R(1'b0), .CE(genTime2), .D(rnd), .Q(rndTime2));
FDRE #(.INIT(1'b0) ) RndLength2[7:0] (.C(clk), .R(1'b0), .CE(genLength2), .D(rnd), .Q(rndLength2));

wire [14:0] length1 = 15'd63 + rndLength1;
wire [14:0] length2 = 15'd63 + rndLength2;

//if front1 <= rndLength1, train1back = 0,
//otherwise train1back = front1 - length1
//if front2 <= rndLength2, train2back = 0,
//otherwise train2back = front2 - length2;
assign train1Back = ({15{(tempfront1 > length1)}} & (tempfront1 - length1));
assign train2Back = ({15{(tempfront2 > length2)}} & (tempfront2 - length2));

wire counting1, counting2;
FDRE #(.INIT(1'b0) ) countingDown1 (.C(clk), .R(train1Back > 15'd478), .CE(start1), .D(1'b1), .Q(counting1));
FDRE #(.INIT(1'b0) ) countingDown2 (.C(clk), .R(train2Back > 15'd478), .CE(start2), .D(1'b1), .Q(counting2));

//assign debug = (rndLength2 >= 8'd63);
countUD15L Front1(.CE(((counting1 & frame) & ~stop) | start1), .UD(1'b1), .clk(clk), .LD(start1), .Din(16'b0), .Q(tempfront1));
countUD15L Front2(.CE(((counting2 & frame) & ~stop) | start2), .UD(1'b1), .clk(clk), .LD(start2), .Din(16'b0), .Q(tempfront2));

//if tempfront1 >= 480, front1 = 480, else front1 = tempfront1
//if tempfront2 >= 480, front2 = 480, else front2 = tempfront2
assign front1 = ({15{(tempfront1 > 15'h01E0)}} & 15'h01DF) | ({15{(tempfront1 <= 15'h01E0)}} & tempfront1);
assign front2 = ({15{(tempfront2 > 15'h01E0)}} & 15'h01DF) | ({15{(tempfront2 <= 15'h01E0)}} & tempfront2);

assign point = train1Back == frontPos | train2Back == frontPos;
assign trainOn = (H > Hpos) & (H < (Hpos + 15'h03C)) & ((V < (front1) & V > train1Back) | (V < front2 & V > train2Back));
//assign trainOn = (H > Hpos) & (H < (Hpos + 15'h028)) & (V < 80) & V > 20;

endmodule
