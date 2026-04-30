module formula_2_pipe
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

   

    wire        isqrt_c_vld;
    wire [15:0] isqrt_c;
    
    wire        isqrt_bc_vld;
    wire [15:0] isqrt_bc;
    
    wire        isqrt_abc_vld;
    wire [15:0] isqrt_abc;

  
    localparam ISQRT_LATENCY = 16;

   
    isqrt i_isqrt_c
    (
        .clk   ( clk         ),
        .rst   ( rst         ),
        .x_vld ( arg_vld     ),
        .x     ( c           ),
        .y_vld ( isqrt_c_vld ),
        .y     ( isqrt_c     )
    );

 
    wire [31:0] b_delayed;
    wire        b_vld;
    
    shift_register_with_valid #(.width(32), .depth(ISQRT_LATENCY)) i_shift_b
    (
        .clk      ( clk        ),
        .rst      ( rst        ),
        .in_vld   ( arg_vld    ),
        .in_data  ( b          ),
        .out_vld  ( b_vld      ),
        .out_data ( b_delayed  )
    );

    wire [31:0] sum_bc =  (b_delayed) +  (isqrt_c);

 
    isqrt i_isqrt_bc
    (
        .clk   ( clk          ),
        .rst   ( rst          ),
        .x_vld ( isqrt_c_vld  ),
        .x     ( sum_bc       ),
        .y_vld ( isqrt_bc_vld ),
        .y     ( isqrt_bc     )
    );


    wire [31:0] a_delayed;
    wire        a_vld;
    
    shift_register_with_valid #(.width(32), .depth(2 * ISQRT_LATENCY)) i_shift_a
    (
        .clk      ( clk       ),
        .rst      ( rst       ),
        .in_vld   ( arg_vld   ),
        .in_data  ( a         ),
        .out_vld  ( a_vld     ),
        .out_data ( a_delayed )
    );

    wire [31:0] sum_abc =  (a_delayed) + (isqrt_bc);

    
    isqrt i_isqrt_abc
    (
        .clk   ( clk           ),
        .rst   ( rst           ),
        .x_vld ( isqrt_bc_vld  ),
        .x     ( sum_abc       ),
        .y_vld ( isqrt_abc_vld ),
        .y     ( isqrt_abc     )
    );

    assign res_vld = isqrt_abc_vld;
    assign res     = (isqrt_abc);

endmodule