//`include "piso.v"
//`include "d_flipflop.v"
//`include "full_adder.v"

module d_flipflop(d, clk, enable, reset, d_out);
  input d, clk, enable, reset;
  output reg d_out;

  

  always @ (posedge clk or posedge reset) begin
    if (reset)
      d_out = 0;
    else
      if (enable)
        d_out <= d;
  end
endmodule

module full_adder(a, b, cin, sum, cout);
  input a, b, cin;
  output sum, cout;

  assign {cout, sum} = a + b + cin;

endmodule

module piso(clk, enable, rst, reg_data, inpreg_out);
  input enable, clk, rst;
  input [3:0] reg_data;
  output reg inpreg_out;
  
  reg [3:0] memory;

  always @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
      inpreg_out <= 1'b0;
      memory <= reg_data;
    end
    else begin
      if (enable) begin
        inpreg_out = memory[0];
        memory = memory >> 1'b1;
      end
    end
  end
endmodule

module serial_adder(data_a, data_b, clk, reset, out, cout);
  parameter d_w=4;
  input [d_w-1:0] data_a, data_b;
  input clk, reset;
  output cout;
  output [4:0] out;

  reg [4:0] out;
  reg [2:0] count;
  reg enable, cout;
  wire wire_a, wire_b, cout_temp, cin, sum;

  piso piso_a(clk, enable, reset, data_a, wire_a);
  piso piso_b(clk, enable, reset, data_b, wire_b);
  full_adder adder(wire_a, wire_b, cin, sum, cout_temp);
  d_flipflop dff(cout_temp, clk, enable, reset, cin);

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      enable = 1; count = 3'b000; out = 5'b00000;
    end
    else begin
      if (count > 3'b100)
        enable = 0;
      else begin
        if (enable) begin
          cout = cout_temp;
          count = count + 1;
          out = out >> 1;
          out[4] = sum;
        end
      end
    end
  end
endmodule
