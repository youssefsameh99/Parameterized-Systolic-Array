module systolic_array #(
parameter DATAWIDTH = 8,
parameter N_SIZE = 5)(
input clk,rst_n,valid_in,
input [N_SIZE*DATAWIDTH-1:0] matrix_a_in,matrix_b_in,
output reg valid_out,
output reg [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out
);


wire [DATAWIDTH-1:0] a_reg[0:N_SIZE-1];
wire [DATAWIDTH-1:0] b_reg[0:N_SIZE-1];
assign a_reg[0]= (valid_in) ? matrix_a_in[DATAWIDTH-1 : 0] : {DATAWIDTH{1'b0}};
assign b_reg[0]= (valid_in) ? matrix_b_in[DATAWIDTH-1 : 0] : {DATAWIDTH{1'b0}};

genvar i, j;
generate
    for (i = 1; i < N_SIZE; i = i + 1) begin : A_PIPE
        wire [DATAWIDTH-1:0] a_input = valid_in ? matrix_a_in[(i+1)*DATAWIDTH-1 -: DATAWIDTH] : {DATAWIDTH{1'b0}};
        REG #(.WIDTH(DATAWIDTH), .DELAY_STAGES(i)) A(
            clk,
            rst_n,
            a_input,
            a_reg[i]
        );
    end

    for (j = 1; j < N_SIZE; j = j + 1) begin : B_PIPE
        wire [DATAWIDTH-1:0] b_input = valid_in ? matrix_b_in[(j+1)*DATAWIDTH-1 -: DATAWIDTH] : {DATAWIDTH{1'b0}};
        REG #(.WIDTH(DATAWIDTH), .DELAY_STAGES(j)) B(
            clk,
            rst_n,
            b_input,
            b_reg[j]
        );
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

reg [N_SIZE] clk_counter;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clk_counter <= 0;
    end
    else clk_counter <= clk_counter + 1;
end


integer out_col;
always @(*) begin
    if (clk_counter >= 2*N_SIZE - 1 && clk_counter <= 3*N_SIZE - 2) begin
        valid_out = 1'b1;
        for (out_col = 0; out_col < N_SIZE; out_col = out_col + 1) begin
            matrix_c_out[(out_col+1)*2*DATAWIDTH-1 -: 2*DATAWIDTH] = 
                c[clk_counter - (2*N_SIZE - 1)][out_col];
        end
    end else begin
        matrix_c_out = 'b0;
        valid_out = 1'b0;
    end
end










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


 module PE#(parameter data_size=8)(
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
