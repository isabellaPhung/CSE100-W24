`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 10:56:22 AM
// Design Name: 
// Module Name: test
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


module test();
reg clkin, frame;
//testing top
reg btnC, btnU, btnL, btnR, btnD;
reg [15:0] sw;
wire [3:0] vgaBlue, vgaRed, vgaGreen;
wire [6:0] seg;
wire [3:0] an;
wire dp, Vsync, Hsync;
wire [15:0] led;
/*
topL6W24 UUT(
    .debugFrame(frame),
    .btnC(btnC),
    .btnU(btnU),
    .btnL(btnL),
    .btnR(btnR),
    .btnD(btnD),
    .sw(sw),
    .clkin(clkin),
    .vgaBlue(vgaBlue),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .seg(seg),
    .an(an),
    .Vsync(Vsync),
    .Hsync(Hsync),
    .led(led),
    .dp(dp));
*/
/*
//testing counter for weirdness
reg LD, CE;
reg [14:0] Din;
wire [15:0] Q;
countUD15L UUT(
    .CE(CE), //clock edge
    .UD(1'b1), //up/down, 1 when incrementing, 0 when decrementing
    .LD(LD), //load
    .clk(clkin),
    .Din(Din), //input
    .Q(Q) //output 
    );
*/



//train testing
reg [14:0] V, H;
reg start, stop;
reg [14:0] Hpos, frontPos;
wire point, trainOn;
//wire debug;
trainState UUT(    
    .H(H),
    .V(V),
    .Hpos(Hpos),
    .frontPos(frontPos),
    .start(start),
    .clk(clkin),
    .frameIn(frame),
    .stop(stop), //stop everything when slug is dead
    .point(point),
//  .debug(debug),
    .trainOn(trainOn)
);


/*
//slug testing
reg V, H, btnL, btnR;
wire slugOn;
slug UUT(
    .V(V), //width
    .H(H), //height
    .frame(frame),
    .btnL(btnL),
    .btnR(btnR),
    .clk(clkin),
    .slugOn(slugOn)
);
*/
initial    // Clock process for clkin
    begin
	clkin = 1'b1;
        forever
        begin
            #1 clkin = ~clkin;
        end
    end 
/*
initial
begin
CE = 1'b1;
LD = 1'b0;
Din = 15'd440;
#1000;
LD = 1'b1;
#10;
LD = 1'b0;
Din = 15'b1;
CE = 1'b0;
#10;
CE = 1'b1;
LD = 1'b1;
#10;
LD = 1'b0;
*/

initial    //process for frame
    begin
	frame = 1'b1;
        forever
        begin
            #4 frame = ~frame;
        end
    end    
    
initial
begin
/*
btnL = 1'b0;
btnR = 1'b0;
btnU = 1'b0;
btnD = 1'b0;
btnC = 1'b0;
sw = 16'b0;
#1100;
btnC = 1'b1;
#10;
btnC = 1'b0;
*/

//train testing

V = 15'b0;
H = 15'b0;
Hpos = 15'd369;
frontPos = 15'd440;
start = 1'b0;
stop = 1'b0;
#2000;
start = 1'b1;
#10;
start = 1'b0;



/*
//slug testing
V = 1'b0;
H = 1'b0;
btnL = 1'b0;
btnR = 1'b0;
#1000;
btnR = 1'b1;
#10;
btnR = 1'b0;
#700;
btnL = 1'b1;
#10;
btnL = 1'b0;
*/
end
endmodule
