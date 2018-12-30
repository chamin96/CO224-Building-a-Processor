module two_s_complement (IN,OUT);
  input signed [7:0] IN;
  output signed [7:0] OUT;

  assign OUT = ~IN + 8'b00000001;

endmodule //two_s_complement

module mux (IN1,IN2,SELECT,OUT,CLK);
  input [7:0] IN1,IN2;
  input SELECT,CLK;
  output reg [7:0] OUT;

  always @ (negedge CLK) begin
    case (SELECT)
      0: OUT<=IN1;
      1: OUT<=IN2;
      default: OUT<=0;
    endcase
  end

endmodule //mux 2 to 1

module testbench_for_two_s;
  reg [7:0] IN;
  wire [7:0] OUT;

  two_s_complement ts(IN,OUT);

  initial begin
    IN=8'b00000010;
    #1 $display ("2s complement of %b is %b.",IN,OUT);
  end

endmodule // testbench
