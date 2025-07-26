 module top#(parameter data_size=8)(
 input clk,reset,
 input [data_size*3-1:0] matrix_a_in,
 input [data_size*3-1:0] matrix_b_in,
 input valid_in,
 output reg valid_out,
 output reg [143:0] matrix_c_out
 );
wire [data_size-1:0] a1,a2,a3,b1,b2,b3;
wire [2*data_size-1:0] sum_out[0:8];

 wire [data_size-1:0] a1to2,a2to3,a4to5,a5to6,a7to8,a8to9,b1to4,b2to5,b3to6,b4to7,b5to8,b6to9;
 wire [data_size-1:0] a2_reg,a3_reg1,a3_reg2,b2_reg,b3_reg1,b3_reg2;

assign a1 = matrix_a_in[data_size-1:0];
assign a2 = matrix_a_in[2*data_size-1:data_size];
assign a3 = matrix_a_in[3*data_size-1:2*data_size];

assign b1 = matrix_b_in[data_size-1:0];
assign b2 = matrix_b_in[2*data_size-1:data_size];
assign b3 = matrix_b_in[3*data_size-1:2*data_size];


DFF dff1(.clk(clk), .rst(reset), .d(a2), .q(a2_reg));
DFF dff2(.clk(clk), .rst(reset), .d(a3), .q(a3_reg1));
DFF dff3(.clk(clk), .rst(reset), .d(a3_reg1), .q(a3_reg2));
DFF dff4(.clk(clk), .rst(reset), .d(b2), .q(b2_reg));
DFF dff5(.clk(clk), .rst(reset), .d(b3), .q(b3_reg1));
DFF dff6(.clk(clk), .rst(reset), .d(b3_reg1), .q(b3_reg2));




 PE PE1 (.clk(clk), .reset(reset), .in_a(a1), .in_b(b1), .out_a(a1to2), .out_b(b1to4), .out_c(sum_out[0]));
 PE PE2 (.clk(clk), .reset(reset), .in_a(a1to2), .in_b(b2_reg), .out_a(a2to3), .out_b(b2to5), .out_c(sum_out[1]));
 PE PE3 (.clk(clk), .reset(reset), .in_a(a2to3), .in_b(b3_reg2), .out_a(), .out_b(b3to6), .out_c(sum_out[2]));
 PE PE4 (.clk(clk), .reset(reset), .in_a(a2_reg), .in_b(b1to4), .out_a(a4to5), .out_b(b4to7), .out_c(sum_out[3]));
 PE PE5 (.clk(clk), .reset(reset), .in_a(a4to5), .in_b(b2to5), .out_a(a5to6), .out_b(b5to8), .out_c(sum_out[4]));
 PE PE6 (.clk(clk), .reset(reset), .in_a(a5to6), .in_b(b3to6), .out_a(), .out_b(b6to9), .out_c(sum_out[5]));
 PE PE7 (.clk(clk), .reset(reset), .in_a(a3_reg2), .in_b(b4to7), .out_a(a7to8), .out_b(), .out_c(sum_out[6]));
 PE PE8 (.clk(clk), .reset(reset), .in_a(a7to8), .in_b(b5to8), .out_a(a8to9), .out_b(), .out_c(sum_out[7]));
 PE PE9 (.clk(clk), .reset(reset), .in_a(a8to9), .in_b(b6to9), .out_a(), .out_b(), .out_c(sum_out[8]));

    reg [2:0] valid_shift;
   always @(posedge clk) begin
    if (reset) begin
      valid_shift <= 0;
    end else begin
      valid_shift <= {valid_shift[2:0], valid_in};
    end
  end

  always @(posedge clk) begin
    if (reset)
      valid_out <= 0;
    else
      valid_out <= valid_shift[2];
  end

    always @(posedge clk) begin
        if (reset) begin
        matrix_c_out <= 0;
        end else begin
        matrix_c_out <= {sum_out[0], sum_out[1], sum_out[2], sum_out[3], sum_out[4], sum_out[5], sum_out[6], sum_out[7], sum_out[8]};
        end
    end




 endmodule


 module PE#(parameter data_size=8)(
 input wire reset,clk,
 input wire [data_size-1:0] in_a,in_b,
 output reg [2*data_size-1:0] out_c,
 output reg [data_size-1:0] out_a,out_b
 );

 always @(posedge clk)begin
 if(reset) begin
 out_a <= 0;
 out_b <= 0;
 out_c <= 0;
 end
 else begin  
out_c <= out_c + in_a*in_b;
 out_a <= in_a;
 out_b <= in_b;
 end
 end
 endmodule



module DFF #(parameter data_size = 8)(
    input clk,
    input rst,
    input [data_size-1:0] d,
    output reg [data_size-1:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule
