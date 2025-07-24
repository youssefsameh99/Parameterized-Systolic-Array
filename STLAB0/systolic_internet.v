module simple_systolic_array(
    input clk,
    input rst_n,
    input valid_in,
    input [11:0] matrix_a_in,
    input [11:0] matrix_b_in,
    output [23:0] matrix_c_out,
    output valid_out
);
 wire [3:0] a1,a2,a3,b1,b2,b3;
 wire [3:0] a2_reg,a3_reg1,a3_reg2,b2_reg,b3_reg1,b3_reg2;
 wire [8:0] c1,c2,c3,c4,c5,c6,c7,c8,c9;


DFF dff_a1(clk , rst_n , a2, a2_reg);
DFF dff_a2(clk , rst_n , a3, a3_reg1);
DFF dff_a22(clk , rst_n , a3_reg1, a3_reg2);


DFF dff_b1(clk , rst_n , b2, b2_reg);
DFF dff_b2(clk , rst_n , b3, b3_reg1);
DFF dff_b22(clk , rst_n , b3, b3_reg2);
 
 wire [3:0] a12,a23,a45,a56,a78,a89,b14,b25,b36,b47,b58,b69;
 
 pe pe1 (.clk(clk), .reset(reset), .in_a(a1), .in_b(b1), .out_a(a12), .out_b(b14), .out_c(c1));
 pe pe2 (.clk(clk), .reset(reset), .in_a(a12), .in_b(b2), .out_a(a23), .out_b(b25), .out_c(c2));
 pe pe3 (.clk(clk), .reset(reset), .in_a(a23), .in_b(b3), .out_a(), .out_b(b36), .out_c(c3));
 pe pe4 (.clk(clk), .reset(reset), .in_a(a2_reg), .in_b(b14), .out_a(a45), .out_b(b47), .out_c(c4));
 pe pe5 (.clk(clk), .reset(reset), .in_a(a45), .in_b(b25), .out_a(a56), .out_b(b58), .out_c(c5));
 pe pe6 (.clk(clk), .reset(reset), .in_a(a56), .in_b(b36), .out_a(), .out_b(b69), .out_c(c6));
 pe pe7 (.clk(clk), .reset(reset), .in_a(a3_reg2), .in_b(b47), .out_a(a78), .out_b(), .out_c(c7));
 pe pe8 (.clk(clk), .reset(reset), .in_a(a78), .in_b(b58), .out_a(a89), .out_b(), .out_c(c8));
 pe pe9 (.clk(clk), .reset(reset), .in_a(a89), .in_b(b69), .out_a(), .out_b(), .out_c(c9));

endmodule

module PE(clk,reset,in_a,in_b,out_a,out_b,out_c);

 parameter data_size=8;
 input wire reset,clk;
 input wire [data_size-1:0] in_a,in_b;
 output reg [2*data_size:0] out_c;
 output reg [data_size-1:0] out_a,out_b;

 always @(posedge clk)begin
    if(reset) begin
      out_a=0;
      out_b=0;
      out_c=0;
    end
    else begin  
      out_c=out_c+in_a*in_b;
      out_a=in_a;
      out_b=in_b;
    end
 end
 
endmodule

module DFF(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule