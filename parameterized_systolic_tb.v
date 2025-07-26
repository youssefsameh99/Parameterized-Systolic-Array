 module testparameterized;

 reg clk;
 reg reset;
reg [23:0] matrix_a_in, matrix_b_in;
 reg valid_in;
 
wire [47:0] matrix_c_out;

 
 systolic_array uut (
 .clk(clk), 
.rst_n(reset), 
.matrix_a_in(matrix_a_in),
.matrix_b_in(matrix_b_in),
.valid_in(valid_in),
.valid_out(valid_out),
.matrix_c_out(matrix_c_out)
 );

 initial begin
 reset = 0;
 valid_in = 0;
      valid_in = 0;
     matrix_a_in = 24'h000000; // Initialize to zero
     matrix_b_in = 24'h000000; // Initialize to zero    
 @(posedge clk); reset = 1;
 @(posedge clk); reset = 0;
     valid_in = 1; // Indicate valid input
     matrix_a_in = 24'h070401; // Example values for matrix A
     matrix_b_in = 24'h030102; // Example values for matrix B
     @(posedge clk);
        matrix_a_in = 24'h080502; // Example values for matrix A
        matrix_b_in = 24'h070504; // Example values for matrix B
        @(posedge clk);
        matrix_a_in = 24'h090603; // Example values for matrix A
        matrix_b_in = 24'h080906; // Example values for matrix B
        @(posedge clk); // Clear valid input after processing
        valid_in = 0; // Indicate valid input
         matrix_a_in = 24'h000000; // Example values for matrix A
        matrix_b_in = 24'h000000;

        repeat(10) @(posedge clk); // Wait for some cycles to observe outputs
 

 #100;
 $stop;
 end


 initial begin
     clk = 0;
 forever #1 clk = ~clk;
 end
 endmodule



// module testparameterized;

//     reg clk;
//     reg reset;
//     reg [39:0] matrix_a_in, matrix_b_in; // 5 * 8 = 40 bits
//     reg valid_in;
//     wire valid_out;
//     wire [79:0] matrix_c_out; // 5 * 16 = 80 bits

//     systolic_array #(
//         .DATAWIDTH(8),
//         .N_SIZE(5)
//     ) uut (
//         .clk(clk),
//         .rst_n(reset),
//         .matrix_a_in(matrix_a_in),
//         .matrix_b_in(matrix_b_in),
//         .valid_in(valid_in),
//         .valid_out(valid_out),
//         .matrix_c_out(matrix_c_out)
//     );

//     initial begin
//         clk = 0;
//         reset = 0;
//         valid_in = 0;
//         matrix_a_in = 40'h0000000000; // Initialize to zero
//         matrix_b_in = 40'h0000000000; // Initialize to zero
        
//         // Reset
//         @(posedge clk); reset = 1;
//         @(posedge clk); reset = 0;

//         // Input data (5 columns of A, 5 rows of B)
//         valid_in = 1;
//         // Column 1 of A, Row 1 of B
//         matrix_a_in = 40'h0504030201; // [1, 2, 3, 4, 5] (big-endian)
//         matrix_b_in = 40'h0B0A060401;    // [1, 2, 3, 4, 5] (big-endian)
//         @(posedge clk);
//         // Column 2 of A, Row 2 of B
//         matrix_a_in = 40'h0A06050403; // [3, 4, 5, 6, 10]
//         matrix_b_in = 40'h0C0B070502;    // [4, 5, 6, 7, 10]
//         @(posedge clk);
//         // Column 3 of A, Row 3 of B
//         matrix_a_in = 40'h0F0B0A0706; // [6, 7, 10, 11, 15]
//         matrix_b_in = 40'h0D0C0A0603;    // [6, 7, 10, 11, 15]
//         @(posedge clk);
//         // Column 4 of A, Row 4 of B
//         matrix_a_in = 40'h140E0D0C0A; // [10, 12, 13, 14, 20]
//         matrix_b_in = 40'h130D0B0704;    // [10, 11, 12, 13, 20]
//         @(posedge clk);
//         // Column 5 of A, Row 5 of B
//         matrix_a_in = 40'h190E0D0C0B; // [11, 12, 13, 14, 25]
//         matrix_b_in = 40'h19140F0B05;    // [11, 12, 13, 19, 25]
//         @(posedge clk);

//         valid_in = 0;
//         matrix_a_in = 40'h0000000000;
//         matrix_b_in = 40'h0000000000;

//         // Wait for output (2*N_SIZE + 1 = 11 cycles)
//         repeat(11) @(posedge clk);
//         #100;
//         $stop;
//     end

//     initial begin
//         clk = 0;
//         forever #1 clk = ~clk;
//     end
// endmodule