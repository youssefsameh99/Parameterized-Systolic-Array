module test();
reg clk, reset;
reg [23:0] matrix_a_in, matrix_b_in;
reg valid_in; 
wire valid_out;
wire [144:0] matrix_c_out;
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
  clk = 0;
  forever #1 clk = ~clk; // Clock period of 2 time units
end

initial begin
  reset = 1;
  valid_in = 0;
  matrix_a_in = 24'h000000; // Initialize to zero
  matrix_b_in = 24'h000000; // Initialize to zero
  
 reset = 1; // Release reset after 5 time units
  @(negedge clk);
  valid_in = 1; // Indicate valid input
  reset = 0; // Assert reset again for a short duration
  matrix_a_in = 24'h741; // Example values for matrix A
  matrix_b_in = 24'h312; // Example values for matrix B
  @(negedge clk);
    matrix_a_in = 24'h852; // Example values for matrix A
  matrix_b_in = 24'h754; // Example values for matrix B
  @(negedge clk);
  matrix_a_in = 24'h963; // Example values for matrix A
  matrix_b_in = 24'h896; // Example values for matrix B
  @(negedge clk);
  valid_in = 0; // Clear valid input after processing
  repeat(10) @(negedge clk); // Wait for some cycles to observe outputs
  
  $stop; // End simulation
end
endmodule
