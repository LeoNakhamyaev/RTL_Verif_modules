module formula_2_pipe_using_circular
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

  
    localparam ISQRT_LATENCY = 16;

    wire [15:0] isqrt_c_y;
    wire        isqrt_c_vld;

    wire [15:0] isqrt_b_y;
    wire        isqrt_b_vld;

    wire [15:0] isqrt_a_y;
    wire        isqrt_a_vld;

    
    isqrt #(.n_pipe_stages(16)) u_isqrt_c (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (c),
        .y_vld (isqrt_c_vld),
        .y     (isqrt_c_y)
    );

    wire [31:0] b_delayed;
    wire        b_vld;
    
    circular_buffer_with_valid #(.width(32), .depth(ISQRT_LATENCY)) u_cb_b (
        .clk       (clk),
        .rst       (rst),
        .in_valid  (arg_vld),
        .in_data   (b),
        .out_valid (b_vld),
        .out_data  (b_delayed)
    );


    isqrt #(.n_pipe_stages(16)) u_isqrt_b (
        .clk   (clk),
        .rst   (rst),
        .x_vld (isqrt_c_vld),
        .x     (b_delayed + {16'h0000, isqrt_c_y}),
        .y_vld (isqrt_b_vld),
        .y     (isqrt_b_y)
    );


    wire [31:0] a_delayed;
    wire        a_vld;

    circular_buffer_with_valid #(.width(32), .depth(2 * ISQRT_LATENCY)) u_cb_a (
        .clk       (clk),
        .rst       (rst),
        .in_valid  (arg_vld),
        .in_data   (a),
        .out_valid (a_vld),
        .out_data  (a_delayed)
    );

 
    isqrt #(.n_pipe_stages(16)) u_isqrt_a (
        .clk   (clk),
        .rst   (rst),
        .x_vld (isqrt_b_vld),
        .x     (a_delayed + {16'h0000, isqrt_b_y}),
        .y_vld (isqrt_a_vld),
        .y     (isqrt_a_y)
    );

  
    assign res_vld = isqrt_a_vld;
    assign res     = {16'h0000, isqrt_a_y};

endmodule