module double_tokens_with_flow_control
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

    logic [7:0] tokens_count;
    logic       error;

    wire up_handshake   = up_ready & up_valid;
    wire down_handshake = down_ready & down_valid;

    always_ff @(posedge clk)
      if (rst ) begin
        tokens_count <= '0;
        error        <= '0;
      end
      else begin
        if (up_handshake  &  down_handshake & up_token )  tokens_count <= tokens_count + 1;
        if (up_handshake  & ~down_handshake & up_token)   tokens_count <= tokens_count + 2;
        if (
           ((tokens_count  > '0) & down_handshake) &
           (~up_handshake |  ~up_token ))                 tokens_count <= tokens_count - 1;

      end

      assign down_data  = (up_token & up_valid) | (|tokens_count);
      assign down_valid = ~error;
      assign up_ready   = (tokens_count < 200);


endmodule