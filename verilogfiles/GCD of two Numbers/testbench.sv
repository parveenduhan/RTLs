module gcd_test;
  reg [15:0] A_in, B_in, A_gen, B_gen;
  reg clk,reset, operands_val, ack_rcvd;
  wire [15:0] gcd_out, out_behav;
  wire gcd_valid, ready;
  
  integer delay,i;
  
  main gcd_rtl1(.clk(clk),
                   .reset(reset),
                .operands_valid(operands_val),
                   .A_in(A_in),
                   .B_in(B_in),
                .ack(ack_rcvd),
                   .gcd_valid(gcd_valid),
                   .ready(ready),
                   .gcd_out(gcd_out)
                  );
  
  gcd_behav gcd_behav1(.inA(A_in), .inB(B_in), .Y(out_behav));
  
  
  always 
    #10 clk = ~clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
  
  initial 
    begin 
      drive_reset();
     
      A_gen=32;
      B_gen=16;
      drive_input(A_gen,B_gen);
      check_output();

   
      repeat(20)@(negedge clk)
      
    
  $finish;
    end
  
  task drive_reset();
    $display ("Driving the reset");
    clk = 1'b0;
    @ (negedge clk)
    reset = 0;
    @ (negedge clk)
    reset = 1;
    @ (negedge clk)
    reset = 0;
  endtask 
  
  task drive_input(input [15:0] A_gen, B_gen);
    $display ("Driving the Input");
       @ (negedge clk)  
        operands_val = 1;
        A_in = A_gen;
        B_in= B_gen;
    @ (negedge clk)
        operands_val = 0;
  endtask 
  
  task check_output();
    @ (posedge gcd_valid)
    $display ("Recieved GCD Valid");
    if(gcd_out == out_behav)
      $display ("Test Succeeded");
    else
      $display("Test failed");
    
    delay = $urandom % 20;
    repeat(delay)@(negedge clk)
    ack_rcvd = 1;
    
      
  endtask 
  
endmodule 
module gcd_behav
(
  input [15-1:0] inA, inB,
  output [15-1:0] Y
);
  reg [15-1:0] A, B, Y, swap;
  integer      done;
                                     
   always @(*)
   begin
     done = 0;
     A = inA; B = inB;
     while ( !done )
     begin
       if ( A < B )
        begin
         swap = A;
         A = B;
         B = swap;
        end
       else if ( B != 0 )
         A = A - B;
       else
         done = 1;
     end
     Y = A;
   end
endmodule
    
