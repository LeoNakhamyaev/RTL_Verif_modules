module generate_tokens_by_number_with_flow_control
#(
    parameter WIDTH = 4
)
(
    input                clk,
    input                rst,

    input                up_valid,
    output logic         up_ready,
    input  [WIDTH-1 : 0] n_tokens,

    output logic         down_valid,
    input                down_ready,
    output logic         down_token
);

   
    logic [WIDTH-1 : 0] cnt;

   
    assign up_ready = (cnt == 0);

    
    assign down_valid = (cnt > 0);
    
   
    assign down_token = (cnt > 0);

    always_ff @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
        end else begin
            if (up_valid && up_ready) begin
               
                cnt <= n_tokens;
            end 
            else if (down_valid && down_ready) begin
                cnt <= cnt - 1;
            end
        end
    end

endmodule