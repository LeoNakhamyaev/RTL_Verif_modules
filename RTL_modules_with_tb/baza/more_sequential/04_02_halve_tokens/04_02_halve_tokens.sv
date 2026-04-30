module halve_tokens (
  input  logic clk,
  input  logic rst,
  input  logic a,
  output logic b
); 
     logic par_cnt; 

    always_ff @(posedge clk, posedge rst) begin
        if (rst) 
            par_cnt <= 0;
        else if (a)
            par_cnt <= ~par_cnt;
    end

    assign b = a && par_cnt;


endmodule