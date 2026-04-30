module convert_first_to_last_with_flow_control #(
    parameter int width = 8
)(
    input  logic               clock,
    input  logic               reset,

    input  logic               up_valid,
    output logic               up_ready,
    input  logic               up_first,
    input  logic               up_last,  
    input  logic [width-1:0]   up_data,

    
    output logic               down_valid,
    input  logic               down_ready,
    output logic               down_first,
    output logic               down_last,
    output logic [width-1:0]   down_data
);

    
    logic               buf_valid;
    logic               buf_first;
    logic [width-1:0]   buf_data;

    always_ff @(posedge clock) begin
        if (reset) begin
            buf_valid <= 1'b0;
            buf_first <= 1'b0;
            buf_data  <= '0;
        end else if (up_valid && up_ready) begin
       
            buf_valid <= 1'b1;
            buf_first <= up_first;
            buf_data  <= up_data;
        end
    end

 
    assign down_valid = buf_valid && up_valid;
    assign down_data  = buf_data;
    assign down_first = buf_first;
    assign down_last  = up_first;
    assign up_ready   = !buf_valid || down_ready;

endmodule