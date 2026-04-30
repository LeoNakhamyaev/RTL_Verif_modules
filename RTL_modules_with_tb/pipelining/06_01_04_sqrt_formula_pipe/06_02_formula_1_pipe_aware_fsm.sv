module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

     
    enum logic [2:0]
    {
        IDLE       = 3'd0, 
        WAIT_A     = 3'd1,  
        WAIT_B     = 3'd2,  
        WAIT_C     = 3'd3   
    }
    state, next_state;


    logic [15:0] sqrt_a, sqrt_b;

   

    always_comb
    begin
        next_state    = state;
        isqrt_x_vld   = 1'b0;
       

        case (state)
        IDLE:
        begin
            if (arg_vld)
            begin
                isqrt_x     = a;
                isqrt_x_vld = 1'b1;
                next_state  = WAIT_A;
            end
        end

        WAIT_A:
        begin
            if (isqrt_y_vld)
            begin
                isqrt_x     = b;
                isqrt_x_vld = 1'b1;
                next_state  = WAIT_B;
            end
        end

        WAIT_B:
        begin
            if (isqrt_y_vld)
            begin
                isqrt_x     = c;
                isqrt_x_vld = 1'b1;
                next_state  = WAIT_C;
            end
        end

        WAIT_C:
        begin
            if (isqrt_y_vld)
            begin
                next_state = IDLE;
            end
        end

        endcase
    end

    

    always_ff @ (posedge clk)
    begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

   

    always_ff @ (posedge clk)
    begin
        if (rst)
            sqrt_a <= '0;
        else if (state == WAIT_A && isqrt_y_vld)
            sqrt_a <= isqrt_y;
    end

    always_ff @ (posedge clk)
    begin
        if (rst)
            sqrt_b <= '0;
        else if (state == WAIT_B && isqrt_y_vld)
            sqrt_b <= isqrt_y;
    end



    always_ff @ (posedge clk)
    begin
        if (rst)
            res_vld <= 1'b0;
        else
            res_vld <= (state == WAIT_C && isqrt_y_vld);
    end

    always_ff @ (posedge clk)
    begin
        if (rst)
            res <= '0;
        else if (state == WAIT_C && isqrt_y_vld)
            res <=  (sqrt_a) +  (sqrt_b) +  (isqrt_y);
    end
    
endmodule
