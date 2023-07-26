module fibo_tb;
  
  reg clk;
  reg rst;
  wire [7:0] out;
  
  // Instantiate the Fibonacci module
  fibo dut (
    .clk(clk),
    .rst(rst),
    .out(out)
  );
  
  // Clock generation
  always #5 clk = ~clk;
  
  // Reset initialization
  initial begin
    clk = 0;
    rst = 1;
    #10 rst = 0;
  end
  
  // Stimulus
  initial begin
    // Wait for a few clock cycles to stabilize
    #20;
    
    // Display the initial output value
    $display("Fibonacci Output: %d", out);
    
    // Generate Fibonacci sequence for 10 iterations
    repeat (10) begin
      #10;
      $display("Fibonacci Output: %d", out);
    end
    
    // Stop the simulation
    $finish;
  end
  
endmodule
    

