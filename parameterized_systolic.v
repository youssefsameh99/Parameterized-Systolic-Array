module systolic_array (clk,rst_n,valid_in,matrix_a_in,matrix_b_in,valid_out,matrix_c_out);
parameter DATAWIDTH = 8;
parameter N_SIZE = 3;
input clk,rst_n,valid_in;
input [N_SIZE*DATAWIDTH-1:0] matrix_a_in,matrix_b_in;
output reg valid_out;
output reg [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out;
wire [DATAWIDTH-1:0] a_delayed[0:N_SIZE][0:N_SIZE];
wire [DATAWIDTH-1:0] b_delayed[0:N_SIZE][0:N_SIZE];




assign a_delayed[0][0]=matrix_a_in[DATAWIDTH-1 : 0];
assign b_delayed[0][0]=matrix_b_in[DATAWIDTH-1 : 0];


genvar j,i;



generate
    for (i = 1; i < N_SIZE; i = i + 1) begin : gen_a_delay
        REG #(
            .WIDTH(DATAWIDTH),
            .DELAY(i)
        ) A (
            .clk(clk),
            .rst_n(rst_n),
            .d(matrix_a_in[(i+1)*DATAWIDTH-1 -: DATAWIDTH]),
            .q(a_delayed[i][0])
        );
    end
    for (j = 1; j < N_SIZE; j = j + 1) begin : gen_b_delay
        REG #(
            .WIDTH(DATAWIDTH),
            .DELAY(j)
        ) B (
            .clk(clk),
            .rst_n(rst_n),
            .d(matrix_b_in[(j+1)*DATAWIDTH-1 -: DATAWIDTH]),
            .q(b_delayed[0][j])
        );
    end
endgenerate



    wire [2*DATAWIDTH-1:0] c_wires [0:N_SIZE*2-1][0:N_SIZE*2-1];
    generate
        for (i = 0; i < N_SIZE; i = i + 1) begin : ROW
            for (j = 0; j < N_SIZE; j = j + 1) begin : COL
                PE PE_inst (
                    .clk(clk),
                    .reset(rst_n),
                    .in_a(a_delayed[i][j]),
                    .in_b(b_delayed[i][j]),
                    .out_a(a_delayed[i][j+1]),
                    .out_b(b_delayed[i+1][j]),
                    .out_c(c_wires[i][j])
                );
            end
        end
    endgenerate

reg [2*N_SIZE:0] valid_counter;
always @(posedge clk) begin
    if (rst_n) begin
        valid_counter <= 0;
    end else begin
        if (valid_counter < 2*N_SIZE+1) valid_counter <= valid_counter + 1;
    end
end

always @(posedge clk) begin
    if (rst_n)
        valid_out <= 0;
    else begin
        valid_out <= (valid_counter >= N_SIZE+1 && valid_counter <= 2*N_SIZE);
    end
end


integer row, col;
always @(posedge clk) begin // Change to sequential for better timing
    matrix_c_out <= 0;
    if (valid_counter >= N_SIZE + 2 && valid_counter <= 2 * N_SIZE + 1) begin
        row = valid_counter - (N_SIZE + 2);
        for (col = 0; col < N_SIZE; col = col + 1) begin
            matrix_c_out[(col*2*DATAWIDTH) +: 2*DATAWIDTH] <= c_wires[row][col];
        end
    end
end










endmodule







module REG (clk,rst_n,d,q);
    parameter WIDTH = 8;
    parameter DELAY = 1;
    input wire clk;
    input wire rst_n;
    input wire [WIDTH-1:0] d;
    output wire [WIDTH-1:0] q;
    reg [WIDTH-1:0] shift_reg [0:DELAY-1];
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            for (i = 0; i < DELAY; i = i + 1)
                shift_reg[i] <= 0;
        end
         else begin
            shift_reg[0] <= d;
            for (i = 1; i < DELAY; i = i + 1)
            shift_reg[i] <= shift_reg[i-1];
        end
    end
    assign q = shift_reg[DELAY-1];
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