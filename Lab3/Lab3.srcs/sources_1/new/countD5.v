module countD5L(
    input dec, //up/down
    input CE, //clock edge
    input clk,
    output TC,
    output [4:0] Q
    );
     
    wire decTemp;
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .CE(CE), .D(dec ^ Q[0]), .Q(Q[0]));
    assign decTemp = dec & Q[0];
    FDRE #(.INIT(1'b0)) FF2 (.C(clk), .CE(CE), .D(decTemp ^ Q[1]), .Q(Q[1]));
    assign decTemp = decTemp & Q[1];
    FDRE #(.INIT(1'b0)) FE3 (.C(clk), .CE(CE), .D(decTemp ^ Q[2]), .Q(Q[2]));
    assign decTemp = decTemp & Q[2];
    FDRE #(.INIT(1'b0)) FE4 (.C(clk), .CE(CE), .D(decTemp ^ Q[3]), .Q(Q[3]));
    assign decTemp = decTemp & Q[3];
    FDRE #(.INIT(1'b0)) FE5 (.C(clk), .CE(CE), .D(decTemp ^ Q[4]), .Q(Q[4]));
    assign TC = &(~Q);
endmodule
