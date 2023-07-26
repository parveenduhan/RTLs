module sum_N_nos(input clk,
             input reset,
             input ack,
             input N_valid,
             input [2:0]N_in,
             output sum_valid,
             output ready,
             output  [4:0] sum);
  
  wire [1:0] i_mux_sel;
  wire [1:0] sum_mux_sel;
  wire i_eq_1;
  data_path dpi(.clk(clk),
                .i_mux_sel(i_mux_sel),
                .sum_mux_sel(sum_mux_sel),
                .N_in(N_in),
                .sum(sum),
                .i_eq_1(i_eq_1));
  
  control_path cpi(.clk(clk) ,
                   .reset(reset),
                   .N_valid(N_valid),
                   .i_eq_1(i_eq_1),
                   .ack(ack),
                   .i_mux_sel(i_mux_sel),
                   .sum_mux_sel(sum_mux_sel),
                   .sum_valid(sum_valid),
                   .ready(ready));
  
  
endmodule

module data_path(input clk,
                 input [1:0] i_mux_sel,
                 input [1:0] sum_mux_sel,
                 input [2:0] N_in,
                 output reg [4:0]sum,
                 output i_eq_1);
  reg [2:0] i_mux_out,i;
  reg [4:0] sum_mux_out;
  wire [4:0] add_out;
  
  assign add_out=i+sum;
  assign i_eq_1=(i==1);
  
  always @(*)
    begin
      case(i_mux_sel)
        2'b00: i_mux_out=N_in;
        2'b01: i_mux_out=i-1;
        2'b10: i_mux_out=i;
        default: i_mux_out={3{1'bx}};
      endcase
    end
  always @(*)
    begin
      case(sum_mux_sel)
        2'b00: sum_mux_out=0;
        2'b01: sum_mux_out=add_out;
        2'b10: sum_mux_out=sum;
        default: sum_mux_out={5{1'bx}};
      endcase
    end
  
  always @(posedge clk)
    begin
      i<=i_mux_out;
      sum<=sum_mux_out;
    end
endmodule

module control_path (input clk, 
                     input reset,
                     input N_valid,
                     input i_eq_1,
                     input ack,
                     output sum_valid,
                     output [1:0] i_mux_sel,
                     output [1:0] sum_mux_sel,
                     output ready);
  parameter IDLE=2'b00;
  parameter BUSY=2'b01;
  parameter DONE=2'b10;
  
  
  assign sum_valid=(state==DONE);
  assign i_mux_sel=state;
  assign sum_mux_sel=state;
  assign ready=(state==IDLE);
  reg [1:0] state,next_state;
  always @(*)
    begin
      case(state)
        IDLE: if(N_valid) 
          		next_state=BUSY;
        	  else
          		next_state=IDLE;
        BUSY: if(i_eq_1)
          		next_state=DONE;
        	  else
                next_state=BUSY;
        DONE: if(ack)
          		next_state=IDLE;
        	  else
                next_state=DONE;
      endcase
    end
  always @(posedge clk or reset)
    begin 
      if(reset)
        state<=IDLE;
      else
        state<=next_state;
    end
endmodule
  
