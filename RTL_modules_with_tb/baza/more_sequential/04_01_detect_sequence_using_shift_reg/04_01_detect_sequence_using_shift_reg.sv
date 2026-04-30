module detect_4_bit_sequence_using_shift_reg
(
  input  clk,
  input  rst,
  input  new_bit,
  output detected
);


  logic [3:0] shift_reg;

  assign detected =   shift_reg[3] &
                    ~ shift_reg[2] &
                      shift_reg[1] &
                    ~ shift_reg[0];

  always_ff @ (posedge clk)
    if (rst)
      shift_reg <= '0;
    else
      shift_reg <= {shift_reg[2:0], new_bit };

endmodule


module detect_6_bit_sequence_using_shift_reg (
  input  logic clk,
  input  logic rst,
  input  logic new_bit,
  output logic detected
);

    logic [5:0] shift_reg;
    always_ff @ (posedge clk)
        if (rst)
            for (int i=0; i<6; i++)
                shift_reg[i] <= 'b0;
        else begin
            shift_reg[0] <= new_bit;
            for (int i=1; i<6; i++)
                shift_reg[i] <= shift_reg[i-1];
        end
    assign detected = (shift_reg == 'b110011);

endmodule