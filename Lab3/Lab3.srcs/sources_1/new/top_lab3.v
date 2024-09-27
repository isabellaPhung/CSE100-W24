`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/26/2024 02:03:00 PM
// Design Name: 
// Module Name: top_lab3
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


module top_lab3(
    input clkin,
    input btnR,
    input btnU,
    input btnC,
    input btnL,
    input [15:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    wire clk, digsel;
    labCnt_clks slowit(.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));

    //wire btnc;
    //FDRE #(.INIT(1'b0)) btnCCount (.C(clk), .R(1'b1), .CE(1'b1), .D(btnC), .Q(btnc)); //btnc only activates with clock edge
    wire btnCEnable;
    wire [15:0] out;
    assign btnCEnable = btnC & (|(out ^ (15'h7FFC))) & (|(out ^ (15'h7FFD))) & (|(out ^ (15'h7FFE))) & (|(out ^ (15'h7FFF)));
    wire clkedge;

    EdgeDetector edgeDetect(.btnU(btnU), .clk(clk), .out(clkedge));

    //wire upDown, load;
    //FDRE #(.INIT(1'b0)) UDclock (.C(clk), .R(1'b1), .CE(1'b1), .D(sw[0]), .Q(upDown)); //UD only activates with clock edge
    //FDRE #(.INIT(1'b0)) LDclock (.C(clk), .R(1'b1), .CE(1'b1), .D(btnL), .Q(load)); //LD only activates with clock edge
    
    countUD15L counter(.CE(btnCEnable | clkedge | btnL), .UD(sw[0]), .LD(btnL), .clk(clk), .Din(sw[15:1]), .UTC(led[15]), .DTC(led[0]), .Q(out));
    wire [0:3] select, num;
    RingCounter ring(.Advance(digsel), .clk(clk), .out(select));
    Selector selector(.sel(select), .N(out), .H(num));
    hex7seg segNum(.n(num), .leds(seg));
    
    assign an = ~select;
    
    //assign an = 4'b1110;
    assign dp = 1;
endmodule
