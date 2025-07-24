module pe #(parameter LAST = "FALSE")(
    input clk,
    input rst_n,
    input [3:0] a_in,
    input [3:0] b_in,
    input [7:0] sum_in,
    output reg [3:0] a_out,
    output reg [3:0] b_out,
    output reg [7:0] sum_out,
    output valid_out
);
generate;
    if (VALIDOUT == "TRUE") begin
        valid_out = 1'b1;
    end else begin
        valid_out = 1'b0;
    end
endgenerate


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_out <= 0;
            b_out <= 0;
            sum_out <= 0;
        end else begin
            a_out <= a_in;
            b_out <= b_in;
            sum_out <= sum_in + (a_in * b_in);
        end
    end

endmodule
