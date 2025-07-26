 module test;

 reg clk;
 reg reset;
reg [23:0] matrix_a_in, matrix_b_in;
 reg valid_in;
 
wire [47:0] matrix_c_out;

 
 top uut (
 .clk(clk), 
.reset(reset), 
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
