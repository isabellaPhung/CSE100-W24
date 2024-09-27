`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2024 02:59:19 PM
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

reg [3:0] sw;
wire [6:0] out;
hex7seg UUT2(.n(sw), .leds(out));

/*
reg [7:0] i0, i1;
reg s;
wire [7:0] out;
multiplexer8 UUT2(.i0(i0),.i1(i1), .s(s), .out(out));
*/
/*
reg a, b, cin;
wire s, cout;
FA UUT2(.a(a), .b(b), .cin(cin), .s(s), .Cout(cout));
*/
/*
reg [7:0] a, b;
reg cin;
wire [7:0] s;
wire cout, ovfl;
Add8 UUT2(.A(a), .B(b), .Cin(cin), .S(s), .Cout(cout), .ovfl(ovfl));
*/
/*
reg sub;
reg [7:0] a, b;
wire [7:0] s;
wire ovfl;
AddSub8 UUT2(.sub(sub), .a(a), .b(b), .s(s), .ovfl(ovfl));
*/
initial
begin
/*
a = 8'b01111111;
b = 8'b01111111;
sub = 0;
#2000
a = 8'b00000001;
b = 8'b00000011;
#100
a = 8'b00000001;
b = 8'b11111110;
#100
a = 8'b10000000;
b = 8'b10000000;
#100;
a = 8'b11111111;
b = 8'b11111111;
#100;
sub = 1;
a = 8'b11111111;
b = 8'b11111111;
#100;
a = 8'b00000100;
b = 8'b00000010;
#100;
a = 8'b01111111;
b = 8'b10000000;
#100;
*/
/*
a = 8'b01111111;
b = 8'b01111111;
cin = 0;
#2000
a = 8'b00000001;
b = 8'b00000011;
#100
a = 8'b00000001;
b = 8'b11111110;
#100
a = 8'b10000000;
b = 8'b10000000;
#100;
a = 8'b11111111;
b = 8'b11111111;
#100;
a = 8'b01111111;
b = 8'b01111111;
#100;
a = 8'b00000000;
b = 8'b00000000;
cin = 1;
#100
a = 8'b11111111;
b = 8'b00000000;
cin = 1;
*/
/*
a = 0;
b = 0;
cin = 0;
#2000;
a = 1;
b = 0;
cin = 0;
#100;
a = 1;
b = 1;
cin = 0;
#100;
a = 0;
b = 0;
cin = 1;
#100;
a = 0;
b = 1;
cin = 1;
#100;
a = 1;
b = 1;
cin = 1;
#100;
*/
/*
i0 = 8'h24;
i1 = 8'h36;
s = 0;
#2000;
s = 1;
#100;
s = 0;
#100;
*/


sw = 4'b0000;
#1000;
sw = 4'b0001;
#100;
sw = 4'b0010;
#100;
sw = 4'b0011;
#100;
sw = 4'b0100;
#100;
sw = 4'b0101;
#100;
sw = 4'b0110;
#100;
sw = 4'b0111;
#100;
sw = 4'b1000;
#100;
sw = 4'b1001;
#100;
sw = 4'b1010;
#100;
sw = 4'b1011;
#100;
sw = 4'b1100;
#100;
sw = 4'b1101;
#100;
sw = 4'b1110;
#100;
sw = 4'b1111;
#100;

end
endmodule
