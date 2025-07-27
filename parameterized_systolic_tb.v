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

    // DUT instantiation
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

    // Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    int bit_idx;

    // Stimulus
    initial begin
        rst_n = 0;
        valid_in = 0;
        @(negedge clk);
        rst_n = 1;
$display("Input Matrix A =");
$display(" Row 1 : 1  2  3  4  5");
$display(" Row 2 : 6  7  8  9 10");
$display(" Row 3 :11 12 13 14 15");
$display(" Row 4 :16 17 18 19 20");
$display(" Row 5 :21 22 23 24 25");



$display("Input Matrix B =");
$display(" Row 1 : 26 27 28 29 30");
$display(" Row 2 : 31 32 33 34 35");
$display(" Row 3 : 36 37 38 39 40");
$display(" Row 4 : 41 42 43 44 45");
$display(" Row 5 : 46 47 48 49 50");

        // Apply input rows (Matrix A and B as rows/columns)
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
        repeat(4) @(negedge clk);
        $display("output matrix C : ");
        $display("");
$write("Row:1 ");
for (int j = 0; j < N_SIZE; j++) begin
    $write("%0d ", matrix_c_out[j*DATAWIDTH*2 +: DATAWIDTH*2]);
end
$display("");

@(negedge clk);
$write("Row:3 ");
for (int j = 0; j < N_SIZE; j++) begin
    $write("%0d ", matrix_c_out[j*DATAWIDTH*2 +: DATAWIDTH*2]);
end
$display("");
@(negedge clk);
$write("Row:3 ");
for (int j = 0; j < N_SIZE; j++) begin
    $write("%0d ", matrix_c_out[j*DATAWIDTH*2 +: DATAWIDTH*2]);
end
$display("");
@(negedge clk);
$write("Row:4 ");
for (int j = 0; j < N_SIZE; j++) begin
    $write("%0d ", matrix_c_out[j*DATAWIDTH*2 +: DATAWIDTH*2]);
end
$display("");
@(negedge clk);
$write("Row:5 ");
for (int j = 0; j < N_SIZE; j++) begin
    $write("%0d ", matrix_c_out[j*DATAWIDTH*2 +: DATAWIDTH*2]);
end
$display("");




        $display("=== End of Output ===");
        $stop;
    end
endmodule
