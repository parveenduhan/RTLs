module sum_N_nos_tb;
  reg clk,reset,N_valid,ack;
  reg [2:0] N_in;
  
  wire sum_valid,ready;
  wire [4:0] sum;
  
  sum_N_nos sum_instance(.clk(clk),
            .reset(reset),
            .N_valid(N_valid),
            .ack(ack),
            .N_in(N_in),
            .sum_valid(sum_valid),
            .ready(ready),
            .sum(sum));
  
  always 
    #5 clk=~clk;
  
  initial 
    begin
      clk=0;
      reset=0;
      N_valid=0;
      N_in=0;
      ack=0;
      
      #10 reset=1;
      #10 reset=0;
      #10 N_in=0;//$urandom %7;
      N_valid=1;
      #20 N_valid=0;
      #20 ack=1;
      $finish;
    end
  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
    end
endmodule
