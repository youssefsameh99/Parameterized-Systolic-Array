 module top#(parameter data_size=8)(
 input clk,reset,
 input [data_size*3-1:0] matrix_a_in,
 input [data_size*3-1:0] matrix_b_in,
 input valid_in,
 output reg valid_out,
 output reg [data_size*3*2-1:0] matrix_c_out
 
 );
 wire [2*data_size-1:0] c1,c2,c3,c4,c5,c6,c7,c8,c9;



    reg [3:0] counter1;
always @(posedge clk) begin
    if (reset) begin
        counter1 <= 0;
    end else begin
        if (counter1 < 7) counter1 <= counter1 + 1;
    end
end

always @(posedge clk) begin
    if (reset)
        valid_out <= 0;
    else begin
        valid_out <= (counter1 >= 4 && counter1 <= 6); // outputs valid at cycles 4,5,6
    end
end



 
 wire [data_size-1:0] a1to2,a2to3,a4to5,a5to6,a7to8,a8to9,b1to4,b2to5,b3to6,b4to7,b5to8,b6to9;
 wire [data_size-1:0] a2_reg,a3_reg1,a3_reg2,b2_reg,b3_reg1,b3_reg2;

DFF dff1(.clk(clk), .rst_n(reset), .d(matrix_a_in[data_size*2-1:data_size]), .q(a2_reg));
DFF dff2(.clk(clk), .rst_n(reset), .d(matrix_a_in[data_size*3-1:data_size*2]), .q(a3_reg1));
DFF dff3(.clk(clk), .rst_n(reset), .d(a3_reg1), .q(a3_reg2));
DFF dff4(.clk(clk), .rst_n(reset), .d(matrix_b_in[data_size*2-1:data_size]), .q(b2_reg));
DFF dff5(.clk(clk), .rst_n(reset), .d(matrix_b_in[data_size*3-1:data_size*2]), .q(b3_reg1));
DFF dff6(.clk(clk), .rst_n(reset), .d(b3_reg1), .q(b3_reg2));




 PE PE1 (.clk(clk), .reset(reset), .in_a(matrix_a_in[data_size-1:0]), .in_b(matrix_b_in[data_size-1:0]), .out_a(a1to2), .out_b(b1to4), .out_c(c1));
 PE PE2 (.clk(clk), .reset(reset), .in_a(a1to2), .in_b(b2_reg), .out_a(a2to3), .out_b(b2to5), .out_c(c2));
 PE PE3 (.clk(clk), .reset(reset), .in_a(a2to3), .in_b(b3_reg2), .out_a(), .out_b(b3to6), .out_c(c3));
 PE PE4 (.clk(clk), .reset(reset), .in_a(a2_reg), .in_b(b1to4), .out_a(a4to5), .out_b(b4to7), .out_c(c4));
 PE PE5 (.clk(clk), .reset(reset), .in_a(a4to5), .in_b(b2to5), .out_a(a5to6), .out_b(b5to8), .out_c(c5));
 PE PE6 (.clk(clk), .reset(reset), .in_a(a5to6), .in_b(b3to6), .out_a(), .out_b(b6to9), .out_c(c6));
 PE PE7 (.clk(clk), .reset(reset), .in_a(a3_reg2), .in_b(b4to7), .out_a(a7to8), .out_b(), .out_c(c7));
 PE PE8 (.clk(clk), .reset(reset), .in_a(a7to8), .in_b(b5to8), .out_a(a8to9), .out_b(), .out_c(c8));
 PE PE9 (.clk(clk), .reset(reset), .in_a(a8to9), .in_b(b6to9), .out_a(), .out_b(), .out_c(c9));

    always @(*) begin
            case (counter1)
                5: begin
                     matrix_c_out[2*data_size-1:0] = c1; matrix_c_out[data_size*4-1:2*data_size] = c2; matrix_c_out[data_size*6-1:data_size*4] = c3;
                end
                6: begin
                     matrix_c_out[2*data_size-1:0] = c4; matrix_c_out[data_size*4-1:2*data_size] = c5; matrix_c_out[data_size*6-1:data_size*4] = c6;
                end
                7: begin
                     matrix_c_out[2*data_size-1:0] = c7; matrix_c_out[data_size*4-1:2*data_size] = c8; matrix_c_out[data_size*6-1:data_size*4] = c9;
                end
            endcase
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
 end else begin 
out_c <= out_c + in_a*in_b;
 out_a <=in_a;
 out_b <=in_b;
 end
 end
 endmodule



module DFF #(parameter data_size = 8)(
    input clk,
    input rst_n,
    input [data_size-1:0] d,
    output reg [data_size-1:0] q
);
    always @(posedge clk) begin
        if (rst_n) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end
endmodule
