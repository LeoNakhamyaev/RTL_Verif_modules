module gearbox_1_to_2_fc
  # (
      parameter width = 0
    )
  (
        input                  clk,
        input                  rst,
        input                  up_valid,
        output                 up_ready,
        input   [width-1:0]    up_data,
        output                 down_valid,
        output  [2*width-1:0]  down_data,
        input                  down_ready
  ); 

   logic [2*width-1 : 0] token;
   logic [width-1 : 0] first_part;
   logic order, ready;

   wire up_handshake = up_ready & up_valid;
   wire down_handshake = down_ready & down_valid;

  always_ff @(posedge clk)
    if (rst) begin
      order <= 1'b0;                            
      ready <= 1'b0;                             
    end
    else begin

     if (down_handshake) ready <= 1'b0;

     if (up_handshake == 1'b1)
       if (order) begin
       
            token      <= {first_part, up_data};
            order      <= ~order;
            ready      <= 1'b1;
       end
       else begin
      
            first_part <= up_data;
            order      <= ~order;
       end
    end

  assign up_ready   = ~ready | down_handshake;
  assign down_valid = ready;
  assign down_data  = token;


endmodule