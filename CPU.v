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
endmodule // testbench_for_two_s

module testbench_for_mux;
  reg [7:0] IN1,IN2;
  wire [7:0] OUT;
  reg SELECT,CLK;

  initial begin
  //initial values
    CLK=0;
    SELECT=0;
    IN1=5;
    IN2=10;

  //time=3
  #3 $display ("OUT = %d",OUT);
  //time=6
  #6 $display ("OUT = %d",OUT);
  //time=9
  #9 SELECT=1;
  #9 $display ("OUT = %d",OUT);
  //time=12
  #12 $display ("OUT = %d",OUT);
  $finish;
  end

  // Clock generator
  always begin
    #5 CLK = ~CLK; // Toggle clock every 5 ticks
  end

  mux two_to_one_mux(IN1,IN2,SELECT,OUT,CLK);

endmodule // testbench_for_mux
