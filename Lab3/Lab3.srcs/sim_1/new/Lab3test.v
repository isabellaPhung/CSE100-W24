`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2024 09:45:54 AM
// Design Name: 
// Module Name: Lab3test
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


module Lab3test();
/*
reg [3:0] sel;
reg [15:0] N;
wire [3:0] H;
Selector UUT(.sel(sel), .N(N), .H(H));
*/

reg UD, CE, clkin, LD;
reg[15:0] Din;
wire UTC, DTC;
wire[15:0] Q;
countUD15L UUT(.UD(UD), .CE(CE), .LD(LD), .Din(Din), .clk(clkin), .UTC(UTC), .DTC(DTC), .Q(Q));
    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        UD = 1'b0;
        CE = 1'b0;
        LD = 1'b0;
        Din = 15'h7FF0;
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end

/*
reg clkin, btnR, btnU, btnC, btnL;
reg [15:0] sw;
wire [6:0] seg;
wire [3:0] an;
wire [15:0] led;
parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        btnR = 1'b0;
        btnU = 1'b0;
        btnC = 1'b0;
        btnL = 1'b0;
        sw = 16'hfabc;
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
top_lab3 UUT(.clkin(clkin), .btnR(btnR), .btnU(btnU), .btnC(btnC), .btnL(btnL), .sw(sw), .seg(seg), .an(an), .led(led));
*/
/*
reg Advance, clkin;
wire [3:0] out;
parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
RingCounter UUT(.Advance(Advance), .clk(clkin), .out(out));
*/
initial
begin 
/*
#2000;
Advance = 1'b1;
*/
/*
#2000;
//btnL = 1'b1;
btnU = 1'b1;
#1000;
btnU = 1'b0;
#1000;
btnU = 1'b1;
#1000;
btnU = 1'b0;
#1000;
btnU = 1'b1;
#1000;
btnU = 1'b0;
#1000;
btnL = 1'b1;
#1000;
btnL = 1'b0;
btnC = 1'b1;
*/


#2000;
UD = 1'b1;
CE = 1'b1;
LD = 1'b1;
#100;
LD = 1'b0;
CE = 1'b0;
#100;
//Din = 5'h03;
//LD = 1'b1;
CE = 1'b1;
#100;
//LD = 1'b0;
CE = 1'b0;
#100;
CE = 1'b1;


/*
#2000;
btnU = 1'b1;
#100;
btnU = 1'b0;
#100;
btnU = 1'b1;
#100;
btnU = 1'b0;
#100;
btnU = 1'b1;
*/
/*
#2000;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
#100;
Advance = 1'b0;
#100;
Advance = 1'b1;
*/
/*
sel = 4'b1000;
N = 16'h7abc;
#2000;
sel = 4'b0100;
#100;
sel = 4'b0010;
#100;
sel = 4'b0001;
*/


/*
    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    initial    // Clock process for clkin
    begin
        #OFFSET
		  clkin = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
        end
    end
*/
end
endmodule
