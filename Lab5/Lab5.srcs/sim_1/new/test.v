`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2024 05:24:33 PM
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
reg clkin;

reg btnR, btnU, btnC, btnL;
reg [15:0] sw;
wire [15:0] led;
wire [3:0] an;
wire [6:0] seg;
wire dp;
top UUT(
    .clkin(clkin),
    .btnR(btnR), //right player
    .sw(sw), //switchs for loading
    .btnU(btnU), //reset
    .btnC(btnC), //go
    .btnL(btnL), //left player
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

sw = 15'b0;
btnR = 0;
btnL = 0;
btnU = 0;
btnC = 0;
#1000;
sw = 16'h0000;
btnC = 1;
#10;
btnC = 0;
#4600
btnL = 1;
#30
btnL = 0;

end
endmodule
