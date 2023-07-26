module fibo(input clk,
            input rst,
            output  [7:0] out);
  
  wire [7:0] sum_out;
  reg [7:0] Fn_1, Fn_2;
  
  assign out = Fn_2;
  assign sum_out = Fn_1 + Fn_2;
  
  always @ (posedge clk)
    begin
      if(rst)
        begin
          Fn_1 <= 1;
          Fn_2 <= 0;
        end
      
      else
        begin
    	  Fn_1 <= sum_out;
          Fn_2 <= Fn_1;
        end
    end
endmodule
