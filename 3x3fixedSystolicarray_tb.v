 module test;
 // Inputs
 reg clk;
 reg reset;
 reg [7:0] a1;
 reg [7:0] a2;
 reg [7:0] a3;
 reg [7:0] b1;
 reg [7:0] b2;
 reg [7:0] b3;
 // Outputs
 wire [16:0] c1;
 wire [16:0] c2;
 wire [16:0] c3;
 wire [16:0] c4;
 wire [16:0] c5;
 wire [16:0] c6;
 wire [16:0] c7;
 wire [16:0] c8;
 wire [16:0] c9;


 // Instantiate the Unit Under Test (UUT)
 top uut (
 .clk(clk), 
.reset(reset), 
.a1(a1), 
.a2(a2), 
.a3(a3), 
.b1(b1), 
.b2(b2), 
.b3(b3), 
.c1(c1), 
.c2(c2), 
.c3(c3), 
.c4(c4), 
.c5(c5), 
.c6(c6), 
.c7(c7), 
.c8(c8), 
.c9(c9)
 );

 initial begin
 // Initialize Inputs
 clk = 0;
 reset = 0;
 a1 = 0;   a2 = 0;   a3 = 0;   b1 = 0;   b2 = 0;   b3 = 0;
 #5 reset = 1;
 #5 reset = 0;
 @(negedge clk);
 a1 = 8'h01;   a2 = 8'h04;   a3 = 8'h07;   b1 = 8'h02;   b2 = 8'h01;   b3 = 8'h03;
 @(negedge clk);
  a1 = 8'h02;   a2 = 8'h05;   a3 = 8'h08;   b1 = 8'h04;   b2 = 8'h05;   b3 = 8'h07;
    @(negedge clk);
     a1 = 8'h03;   a2 = 8'h06;   a3 = 8'h09;   b1 = 8'h06;   b2 = 8'h09;   b3 = 8'h08;
     @(negedge clk);
     a1 = 0;   a2 = 0;   a3 = 0;   b1 = 0;   b2 = 0;   b3 = 0;
 

 #100;
 $stop;
 end
 initial begin
 forever #1 clk = ~clk;
 end
 endmodule