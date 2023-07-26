// Code your design here
module main(input reset,
            input clk,
            input [15:0] A_in,
            input [15:0] B_in,
           input operands_valid,
           input ack,
           output gcd_valid,
            output [15:0] gcd_out,
           output ready);
   wire [1:0] A_mux_sel;
  wire B_mux_sel,A_en,B_en,A_lt_B,B_eq_zero;
  
  datapath dp(.clk(clk),
              .A_in(A_in),
              .B_in(B_in),
              .A_mux_sel(A_mux_sel),
              .B_mux_sel(B_mux_sel),
              .A_en(A_en),
              .B_en(B_en),
              .A_lt_B(A_lt_B),
              .B_eq_zero(B_eq_zero),
              .gcd_out(gcd_out));
  
 
  
  
  
  controlpath cp(.clk(clk),
                 .reset(reset),
                 .ready(ready),
                 .operands_valid(operands_valid),
                 .ack(ack),
                 .gcd_valid(gcd_valid),
                 .A_mux_sel(A_mux_sel),
                 .B_mux_sel(B_mux_sel),
                 .A_en(A_en),
                 .B_en(B_en),
                 .A_lt_B(A_lt_B),
                 .B_eq_zero(B_eq_zero)
                );
  
  endmodule

module datapath(input clk,
                input [15:0] A_in,
                input [15:0] B_in,
                input [1:0] A_mux_sel,
               input B_mux_sel,
               input A_en,
               input B_en,
               output A_lt_B,
               output B_eq_zero,
                output [15:0] gcd_out);
  wire [15:0] sub_out,B_mux_out;
  reg [15:0] A_mux_out,A,B;
  assign gcd_out = A;
  always @(*)
    begin
      case(A_mux_sel)
        2'b00 : A_mux_out = A_in;
        2'b01 : A_mux_out = B;
        2'b10 : A_mux_out = sub_out;
        default : A_mux_out = {16{1'bx}};
      endcase
    end
  assign B_mux_out = B_mux_sel ? A : B_in;
  
  assign A_lt_B = (A<B);
  assign B_eq_zero = (B==0);
  
  assign sub_out = A-B;
  
  always @(posedge clk)
    begin
      if(A_en)
        A <= A_mux_out;
      if(B_en)
        B <= B_mux_out;
    end
endmodule

module controlpath(input clk,
                  input reset,
                  input operands_valid,
                  input B_eq_zero,
                  input ack,
                  input A_lt_B,
                   output reg [1:0] A_mux_sel,
                  output reg B_mux_sel,
                  output ready,
                  output reg A_en,
                   output reg B_en,
                   output reg gcd_valid);
  
  localparam IDLE = 2'b00;
  localparam BUSY = 2'b01;
  localparam DONE = 2'b10;
  
  reg [1:0] state,next_state;
  
  always @(*)
    begin
      next_state <= state;
      case(state)
        IDLE: if(operands_valid)
          next_state <= BUSY;
        BUSY: if(B_eq_zero)
          next_state <= DONE;
        DONE: if(ack)
          next_state <= IDLE;
      endcase
    end
  
  always @(*)
    begin
      case(state)
        IDLE:
          begin
            A_mux_sel = 2'b00;
            B_mux_sel = 1'b0;
            A_en = 1'b1;
            B_en = 1'b1;
          end
        BUSY:
          begin
            if(A_lt_B)
              begin
              A_mux_sel = 2'b01;
              B_mux_sel = 1'b1;
              A_en = 1'b1;
              B_en = 1'b1;
              end
            else
              begin
              A_mux_sel = 2'b10;
              A_en = 1'b1;
              B_en = 1'b0;
              end
          end
        DONE:
          begin    
        	A_en=0;
        	B_en=0;
        	gcd_valid=1;
          end
      endcase
    end
  
  always @(posedge clk or reset)
    begin
      if(reset)
        state <= IDLE;
      else 
        state <= next_state;
    end
endmodule
  
  
  
  


