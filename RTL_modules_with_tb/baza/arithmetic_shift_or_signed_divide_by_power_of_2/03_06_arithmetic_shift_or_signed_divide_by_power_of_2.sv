module arithmetic_right_shift_of_N_by_S_using_arithmetic_right_shift_operation
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

  wire signed [N - 1:0] as = a;
  assign res = as >>> S;

endmodule



module arithmetic_right_shift_of_N_by_S_using_concatenation
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

wire signed [N - 1 : 0] as = a;

assign res = { {S{a[N-1]}}, a[N-1:S] };

endmodule

module arithmetic_right_shift_of_N_by_S_using_for_inside_always
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output logic [N - 1:0] res);

wire signed [N - 1 : 0] as = a;

always_comb
    for (int i = 0; i < N; i ++)
      res [i] = i > (N - S - 1) ? as[N-1] : a [i + S];

endmodule

module arithmetic_right_shift_of_N_by_S_using_for_inside_generate
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

wire signed [N - 1 : 0] as = a;

genvar i;

  generate
    for (i = 0; i < N; i ++)
      if (i > (N - S - 1)) begin : zero_bit_gen
        assign res [i] = as[N-1];
      end
      else begin : shifted_bit_gen
        assign res [i] = a [i + S];
      end
  endgenerate

endmodule