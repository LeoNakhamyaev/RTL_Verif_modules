module formula_1_pipe (
    input               clk,
    input               rst,
    input               arg_vld,
    input      [31:0]   a,
    input      [31:0]   b,
    input      [31:0]   c,
    output              res_vld,
    output     [31:0]   res
);


    wire [15:0] root_a, root_b, root_c;
    wire        vld_a, vld_b, vld_c;

    isqrt unit_a (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (a),
        .y_vld (vld_a),
        .y     (root_a)
    );

    isqrt unit_b (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (b),
        .y_vld (vld_b),
        .y     (root_b)
    );

    isqrt unit_c (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (c),
        .y_vld (vld_c),
        .y     (root_c)
    );


    assign res_vld = vld_a;
    assign res     = root_a + root_b + root_c;

endmodule
