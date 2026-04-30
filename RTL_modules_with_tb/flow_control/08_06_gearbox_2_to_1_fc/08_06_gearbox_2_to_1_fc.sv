module gearbox_2_to_1_fc
  # (
      parameter width = 0
    )
  (
        input                  clk,
        input                  rst,
        input                  up_valid,
        output                 up_ready,
        input   [2*width-1:0]  up_data,
        output                 down_valid,
        output  [width-1:0]    down_data,
        input                  down_ready
  );




   logic [2*width-1 : 0] token;
 
   logic order, busy;

   wire up_handshake = up_ready & up_valid;
   wire down_handshake = down_ready & down_valid;
   wire end_to_end = up_handshake & down_handshake;

  always_ff @(posedge clk)
    if (rst) begin
      order <= 1'b1;                             
      busy  <= 1'b0;                             
    end
    else begin

     if (up_handshake)                            busy  <= 1'b1;
     else if(down_handshake & ~order)             busy <= 1'b0;

     if (up_handshake)                            token <= up_data;

     if (end_to_end | (busy & down_ready & order))        order <= 1'b0;
     else if (busy & down_handshake & ~order)             order <= 1'b1;
    end
  assign up_ready   = ~busy ;
  assign down_valid =  busy  ;
  assign down_data  = (end_to_end) ? up_data[2*width-1  : width] :
                      (order)      ? token[2*width-1 : width] : token[width-1 : 0];

endmodule