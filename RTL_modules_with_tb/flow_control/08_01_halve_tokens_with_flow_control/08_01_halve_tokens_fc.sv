module halve_tokens_with_flow_control
(
    input              clk,
    input              rst,

    input              up_valid,
    output logic       up_ready,
    input              up_token,

    output logic       down_valid,
    input              down_ready,
    output logic       down_data
);

    logic token_sw;

    always_ff @(posedge clk) begin
        if (rst) begin
            token_sw <= 0;
        end else if (up_valid && down_ready) begin
            if (up_token) begin 
                token_sw <= ~token_sw;
            end
        end
    end

    assign up_ready = down_ready;
    assign down_valid = up_valid;
    assign down_data = up_valid & down_ready & up_token & token_sw;
            

endmodule