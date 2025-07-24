module systolic_array #(
    parameter DATAWIDTH = 16 ,
    parameter N_SIZE = 5
)
(
    input clk,
    input rst_n,
    input valid_in,
    input [N_SIZE*DATAWIDTH:0] matrix_a_in, matrix_b_in ,
    output valid_out,
    output [N_SIZE*2*DATAWIDTH:0] matrix_c_out
);



endmodule