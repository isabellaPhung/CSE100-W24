`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 03:45:06 PM
// Design Name: 
// Module Name: LED_Shifter2
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


module LED_Shifter2(
    input Scored,
    input Failed,
    output [5:0] led,
    input clk
    );
wire [5:0] NS, PS;
//assign NS[4:1] = Scored & PS[5:2] | Failed & PS[3:0];
assign NS[0] = Failed & PS[0] | Scored & PS[1];
assign NS[1] = Failed & PS[0] | Scored & PS[2];
assign NS[2] = Failed & PS[1] | Scored & PS[3];
assign NS[3] = Failed & PS[2] | Scored & PS[4];
assign NS[4] = Failed & PS[3] | Scored & PS[5];
assign NS[5] = Failed & PS[4] | Scored & PS[5];

FDRE #(.INIT(1'b1)) Q0_FF (.C(clk),.R(1'b0),.CE(Failed | Scored),.D(NS[0]),.Q(PS[0]));
FDRE #(.INIT(1'b0)) Q5_FF[5:1] (.C({5{clk}}),.R(5'b0),.CE({5{Failed | Scored}}),.D(NS[5:1]),.Q(PS[5:1]));
assign led = PS;
endmodule
