module systolic_array #(
parameter DATAWIDTH = 8,
parameter N_SIZE = 3)(
input clk,rst_n,valid_in,
input [N_SIZE*DATAWIDTH-1:0] matrix_a_in,matrix_b_in,
output reg valid_out,
output reg [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out
);


wire [DATAWIDTH-1:0] a_reg[0:N_SIZE-1];
wire [DATAWIDTH-1:0] b_reg[0:N_SIZE-1];
assign a_reg[0]=matrix_a_in[DATAWIDTH-1 : 0];
assign b_reg[0]=matrix_b_in[DATAWIDTH-1 : 0];

genvar i, j;
generate
 for ( i=1;i<N_SIZE;i=i+1) begin
 REG #(.WIDTH(DATAWIDTH),.DELAY_STAGES(i)) A(clk,rst_n,matrix_a_in[(i+1)*DATAWIDTH-1 -: DATAWIDTH],a_reg[i]);  
 end   
 for(j=1;j<N_SIZE;j=j+1) begin
 REG #(.WIDTH(DATAWIDTH),.DELAY_STAGES(j)) B(clk,rst_n,matrix_b_in[(j+1)*DATAWIDTH-1 -: DATAWIDTH],b_reg[j]);  
 end
endgenerate

wire   [2*DATAWIDTH-1:0] c [0:N_SIZE-1][0:N_SIZE-1];
wire   [DATAWIDTH-1:0] a_bet_pe     [0:N_SIZE-1][0:N_SIZE-1];
wire   [DATAWIDTH-1:0] b_bet_pe      [0:N_SIZE-1][0:N_SIZE-1];


generate
    for (i = 0; i < N_SIZE; i = i + 1) begin 
    for (j = 0; j < N_SIZE; j = j + 1) begin 
 PE #(.data_size(DATAWIDTH)) pe(clk,rst_n,(j == 0) ? a_reg[i] : a_bet_pe[i][j-1] ,(i == 0) ? b_reg[j] : b_bet_pe[i-1][j]
    , c[i][j], a_bet_pe[i][j],b_bet_pe[i][j]);
        end
    end
endgenerate





endmodule





module REG (clk,rst_n,in,q);
    parameter WIDTH = 8;              
    parameter DELAY_STAGES = 1;              
    input clk,rst_n;
    input  [WIDTH-1:0] in;
    output [WIDTH-1:0] q;
    reg [WIDTH-1:0] Register [0:DELAY_STAGES-1];  
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < DELAY_STAGES; i = i + 1)
                Register[i] <= 0;
        end
         else begin
            Register[0] <= in;
            for (i = 1; i < DELAY_STAGES; i = i + 1)
            Register[i] <= Register[i-1];
        end
    end
    assign q = Register[DELAY_STAGES-1];
endmodule


 module PE#(parameter data_size=8,parameter N_SIZE = 3)(
 input wire clk,rst_n,
 input wire [data_size-1:0] in_a,in_b,
 output reg [2*data_size-1:0] out_c,
 output reg [data_size-1:0] out_a,out_b
 );
 always @(posedge clk)begin
 if(!rst_n) begin
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
