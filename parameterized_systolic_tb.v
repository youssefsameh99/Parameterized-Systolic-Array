
module systolic_array_tb;
    parameter DATAWIDTH = 16;
    parameter N_SIZE = 5;
    reg clk;
    reg rst_n;
    reg valid_in;
    reg [N_SIZE*DATAWIDTH-1:0] matrix_a_in;
    reg [N_SIZE*DATAWIDTH-1:0] matrix_b_in;
    wire valid_out;
    wire [N_SIZE*2*DATAWIDTH-1:0] matrix_c_out;
    systolic_array #(
        .DATAWIDTH(DATAWIDTH),
        .N_SIZE(N_SIZE)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .matrix_a_in(matrix_a_in),
        .matrix_b_in(matrix_b_in),
        .valid_out(valid_out),
        .matrix_c_out(matrix_c_out)
    );
initial begin
    clk = 0;
    forever #1 clk = ~clk;
end
initial begin
    rst_n = 0;
    valid_in = 0;
    @(negedge clk);
    rst_n = 1;
    valid_in = 1;
    matrix_a_in = 80'h00150010000b00060001;
    matrix_b_in = 80'h001e001d001c001b001a;
    @(negedge clk);
    matrix_a_in = 80'h00160011000c00070002;
    matrix_b_in = 80'h0023002200210020001f;
       @(negedge clk);
    matrix_a_in = 80'h00170012000d00080003;
    matrix_b_in = 80'h00280027002600250024;
    @(negedge clk);
    matrix_a_in = 80'h00180013000e00090004;
    matrix_b_in = 80'h002d002c002b002a0029;
    @(negedge clk);
    matrix_a_in = 80'h00190014000f000a0005;
    matrix_b_in = 80'h003200310030002f002e;
    @(negedge clk);
    valid_in = 0;
    repeat(10)@(negedge clk);
    $stop;
end
endmodule

