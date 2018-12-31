/*
	 ________________CPU________________
	         E/15/154 | E/15/142
      _____________________________
              CO224-Lab5
*/

//2's complement
module two_s_complement (IN,OUT);
  input signed [7:0] IN;
  output signed [7:0] OUT;

  assign OUT = ~IN + 8'b00000001;
  //assign OUT [7:0] = -IN [7:0];

endmodule //two_s_complement

//2:1 Multiplexer
module mux (IN1,IN2,SELECT,OUT,clk);
  input [7:0] IN1,IN2;
  input SELECT,clk;
  output reg [7:0] OUT;

  always @ (negedge clk) begin
    case (SELECT)
      0: OUT<=IN1;
      1: OUT<=IN2;
      default: OUT<=0;
    endcase
  end

endmodule //mux 2 to 1

//Program Counter
module counter (clk,reset,Read_addr);
  input reset,clk;
  output reg [7:0] Read_addr;

  always @ (negedge clk) begin
    case (reset)
      0: Read_addr=Read_addr+1;
      1: Read_addr=0;
      default: Read_addr=Read_addr;
    endcase
  end

endmodule // PC

/*
  ____TEST-BENCHES_____
*/
module testbench_for_two_s;
  reg [7:0] IN;
  wire [7:0] OUT;

  two_s_complement ts(IN,OUT);

  initial begin
    IN=8'b00000010;
    #1 $display ("2s complement of %d is %d.",IN,OUT);
  end
endmodule // testbench_for_two_s

module testbench_for_mux;
  reg [7:0] IN1,IN2;
  wire [7:0] OUT;
  reg SELECT,clk;

  initial begin
  //initial values
    clk=0;
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
    #5 clk = ~clk; // Toggle clock every 5 ticks
  end

  mux two_to_one_mux(IN1,IN2,SELECT,OUT,clk);

endmodule // testbench_for_mux

// module testbench_for_PC;
//   reg reset,clk;
//   wire [7:0] Read_addr;
//
//   initial begin
//   //initial values
//     reset=0;
//     Read_addr=8'd3;
//     clk=0;
//   //time=3
//     #3 $display("Counter = %d",Read_addr);
//   //time=6
//     #6 $display("Counter = %d",Read_addr);
//   //time=9
//     #9 reset=1;
//     #9 $display ("Counter = %d",Read_addr);
//   //time=12
//     #12 $display ("Counter = %d",Read_addr);
//     $finish;
//   end
//
//   // Clock generator
//   always begin
//     #5 clk = ~clk; // Toggle clock every 5 ticks
//   end
//
//   counter pc(clk,reset,Read_addr);
//
// endmodule // testbench_for_PC
