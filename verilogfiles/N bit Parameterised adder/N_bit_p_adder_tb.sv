// Code your testbench here
// or browse Examples
//`timescale 1s/100ns
//`include "serial_adder.v"

module serial_adder_tb;
  parameter N=4;
  reg [N:0] data_b;
  reg [N:0] data_a;
  reg clk, reset;

  wire [N:0] out;
  wire cout;

  serial_adder s_adder(data_a, data_b, clk, reset, out, cout);
    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
    end
  initial begin
    $monitor("data_a = %4b, data_b = %4b, reset = %b, out=%b", data_a, data_b, reset, out);
  
   // $dumpfile("serial_adder_tb.vcd");
   // $dumpvars(0, serial_adder_tb);

    
    clk = 0;
     
    data_a = 4'b1101; data_b = 4'b1011; reset = 1;#20
     reset = 0; #200;
    $finish;
  end

  always #10 clk = !clk;

endmodule
