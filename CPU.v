module two_s_complement (IN,OUT);
  input signed [7:0] IN;
  output signed [7:0] OUT;

  assign OUT = ~IN + 8'b00000001;

endmodule //two_s_complement

module testbench;
  reg [7:0] IN;
  wire [7:0] OUT;

  two_s_complement ts(IN,OUT);

  initial begin
    IN=8'b00000010;
    #1 $display ("2s complement of %b is %b.",IN,OUT);
  end

endmodule // testbench
