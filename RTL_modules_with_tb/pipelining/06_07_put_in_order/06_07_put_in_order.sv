module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output                      down_vld,
    output [ width   - 1 : 0 ]  down_data
);

    localparam ptr_width = $clog2(n_inputs);
    logic [width - 1:0] data_reg [n_inputs - 1:0];
    logic [n_inputs - 1:0] data_valid;
    logic [ptr_width - 1:0] expected_ptr;

    
    genvar i;
    generate
        for (i = 0; i < n_inputs; i++) begin
            always_ff @ (posedge clk) begin
                if (rst) begin

                    
                    data_valid[i] <= 1'b0;
                    data_reg[i]   <= '0;
                end
                
                else begin
                    if (up_vlds[i]) begin
                        data_reg[i]   <= up_data[i];
                        data_valid[i] <= 1'b1;
                    end
                    else if ((expected_ptr ==  (i)) && down_vld) begin
                        data_valid[i] <= 1'b0;
                    end
                end
            end
        end
    endgenerate

    
    always_ff @ (posedge clk) begin
        if (rst) begin
            expected_ptr <= '0;
        end
        else if (down_vld) begin
            
            if (expected_ptr == n_inputs - 1)
                expected_ptr <= '0;
            else
                expected_ptr   <= expected_ptr + 1'b1;
        end
    end

    assign down_vld  = data_valid[expected_ptr];
    assign down_data =   data_reg[expected_ptr];

endmodule