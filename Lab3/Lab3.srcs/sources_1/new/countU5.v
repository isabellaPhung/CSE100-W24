module countU5L(
    input inc, //up/down
    input CE, //clock edge
    input clk,
    output TC,
    output [4:0] Q
    );
     
    wire incTemp;
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .CE(CE), .D(inc ^ Q[0]), .Q(Q[0]));
    assign incTemp = inc & Q[0];
    FDRE #(.INIT(1'b0)) FF2 (.C(clk), .CE(CE), .D(incTemp ^ Q[1]), .Q(Q[1]));
    assign incTemp = incTemp & Q[1];
    FDRE #(.INIT(1'b0)) FE3 (.C(clk), .CE(CE), .D(incTemp ^ Q[2]), .Q(Q[2]));
    assign incTemp = incTemp & Q[2];
    FDRE #(.INIT(1'b0)) FE4 (.C(clk), .CE(CE), .D(incTemp ^ Q[3]), .Q(Q[3]));
    assign incTemp = incTemp & Q[3];
    FDRE #(.INIT(1'b0)) FE5 (.C(clk), .CE(CE), .D(incTemp ^ Q[4]), .Q(Q[4]));
    assign TC = &(Q);
endmodule
