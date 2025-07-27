module systolic_array #(
parameter DATAWIDTH = 16,
parameter N_SIZE = 5)(
input clk,rst_n,valid_in,
input [N_SIZE*DATAWIDTH-1:0] matrix_a_in,matrix_b_in,
output reg valid_out,
output reg [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out
);

reg [N_SIZE] clk_counter;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clk_counter <= 0;
    end
    else clk_counter <= clk_counter + 1;
end


wire [DATAWIDTH-1:0] a_reg[0:N_SIZE-1];
wire [DATAWIDTH-1:0] b_reg[0:N_SIZE-1];
assign a_reg[0]= (valid_in) ? matrix_a_in[DATAWIDTH-1 : 0] : {DATAWIDTH{1'b0}};
assign b_reg[0]= (valid_in) ? matrix_b_in[DATAWIDTH-1 : 0] : {DATAWIDTH{1'b0}};

genvar i, j;
generate
    for (i = 1; i < N_SIZE; i = i + 1) begin : A_PIPE
        wire [DATAWIDTH-1:0] a_input = (valid_in) ? matrix_a_in[(i+1)*DATAWIDTH-1 -: DATAWIDTH] : {DATAWIDTH{1'b0}};
        DFF #(.DATAWIDTH(DATAWIDTH), .NUM_DFF(i)) A(
            clk,
            rst_n,
            a_input,
            a_reg[i]
        );
    end

    for (j = 1; j < N_SIZE; j = j + 1) begin : B_PIPE
        wire [DATAWIDTH-1:0] b_input = (valid_in) ? matrix_b_in[(j+1)*DATAWIDTH-1 -: DATAWIDTH] : {DATAWIDTH{1'b0}};
        DFF #(.DATAWIDTH(DATAWIDTH), .NUM_DFF(j)) B(
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





module DFF #(parameter DATAWIDTH = 16, NUM_DFF = 1) (
    input clk,
    input wire rst_n,
    input wire [DATAWIDTH-1:0] d,
    output wire [DATAWIDTH-1:0] q
);
    reg [DATAWIDTH-1:0] stage_array [0:NUM_DFF-1];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_DFF; i = i + 1)
                stage_array[i] <= '0;
        end else begin
            stage_array[0] <= d;
            for (i = 1; i < NUM_DFF; i = i + 1)
                stage_array[i] <= stage_array[i - 1];
        end
    end
    assign q = stage_array[NUM_DFF - 1];
endmodule


 module PE#(parameter data_size=16)(
 input wire clk,rst_n,
 input wire [data_size-1:0] in_a,in_b,
 output reg [2*data_size-1:0] out_c,
 output reg [data_size-1:0] out_a,out_b
 );
 always @(posedge clk or negedge rst_n)begin
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
