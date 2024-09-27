`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Martine
// 
// Create Date: 9/27/2022 09:26:52 PM
// Design Name: 
// Module Name: test_add
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


module test_add( ); // no inputs/outputs, this is a wrapper


// registers to hold values for the inputs to your top level
    reg [15:0] sw;
    reg btnU, btnR, clkin;
// wires to see the values of the outputs of your top level
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;
    wire [15:0] led;

// create one instance of your top level
// and attach it to the registers and wires created above
    top_lab2 UUT (
     .sw(sw),
     .btnU(btnU),
     .btnR(btnR), 
     .clkin(clkin),
     .seg(seg),
     .an(an),
     .led(led),
     .dp(dp)
    );
    
    
// create an oscillating signal to impersonate the clock provided on the BASYS 3 board
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
   initial
   begin
     sw = 16'h0507; //0C dp = 0
	 btnR=1'b0;
	 btnU=1'b0; //sub signal
	 #2000;
	 sw = 16'h0507;
	 btnU=1'b1; // FE dp = 1
	 #100;
	 sw = 16'h8080;
	 btnU=1'b0; //00 dp = 1
	 #100;
	 sw = 16'h7F7F; //ED dp = 1
	 #100;
	 btnU = 1'b1; // 00 dp = 0
	 #100;
	 btnU = 1'b0;
	 sw = 16'hFFFF; //FE dp = 0
	 #100;
	  btnU = 1'b1;
	 sw = 16'h7F80; // FF dp = 1
    end

endmodule
