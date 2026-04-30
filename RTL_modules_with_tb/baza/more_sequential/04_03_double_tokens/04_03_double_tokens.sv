module double_tokens (
  input        clk,
  input        rst,
  input        a,
  output logic b,
  output logic overflow
);

    parameter max_1 = 200;
    parameter overflow_w = $clog2(max_1);
    
    logic [overflow_w:0] cntovrfl;
    logic b_i;

    assign b = a | b_i | (|cntovrfl);

    always_ff @ (posedge clk) begin
        if (rst) begin 
            cntovrfl <= '0;
        end else begin
            if (a) begin
                cntovrfl <= cntovrfl + 1;
            end else if (b_i) begin
                cntovrfl <= cntovrfl - 1;
            end
        end
    end

    always_ff @ (posedge clk) begin
        if (rst) begin 
            overflow <= 1'b0;
        end else begin
            if (max_1 >= cntovrfl) begin
                overflow <= 1'b1;
            end
        end
    end

             
    always_ff @ (posedge clk) begin
        if (rst) begin
            b_i <= 0;
        end else begin
            if (1'b1 == a) begin
                b_i <= 1'b1;
            end else if (cntovrfl == 1) begin
                b_i <= 1'b0;
            end
        end
    end
    
endmodule