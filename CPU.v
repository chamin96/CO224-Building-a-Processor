/*
	 ________________CPU________________
	         E/15/154 | E/15/142
      _____________________________
              CO224-Lab5
*/

//alu module
module alu(RESULT,DATA1,DATA2,SELECT);
    output reg [7:0] RESULT;
    input [7:0] DATA1,DATA2;
    input [2:0] SELECT;

    always @(*)
    begin
        case (SELECT)
            3'b000:
                begin
                    RESULT = DATA1;         //FORWARD
                end
            3'b001:
                begin
                    RESULT = DATA1 + DATA2; //ADD
                end
            3'b010:
                begin
                    RESULT = DATA1 & DATA2; //AND
                end
            3'b011:
                begin
                    RESULT = DATA1 | DATA2; //OR
                end
            default:
                    RESULT = 8'b00000000;
        endcase
    end

endmodule


// Register File
module regfile8x8a ( clk, INaddr, IN, OUT1addr, OUT1, OUT2addr, OUT2);

	input [2:0] OUT1addr,OUT2addr,INaddr;
	input [7:0] IN;
	input clk;
	output reg [7:0] OUT1,OUT2;

	reg [63:0] regMemory = 0;
	reg [7:0] OUT1reg, OUT2reg;
	integer i;

	always @ ( * ) begin
		OUT1 = OUT1reg[7:0];
		OUT2 = OUT2reg[7:0];
	end


	always @(posedge clk) begin
		for(i=0;i<8;i=i+1) begin
			OUT1reg[i] = regMemory[ OUT1addr*8 + i ];
			OUT2reg[i] = regMemory[ OUT2addr*8 + i ];
		end
	end


	always @(negedge clk) begin
		for(i=0;i<8;i=i+1)begin
			regMemory[INaddr*8 + i] = IN[i];
		end
	end

endmodule

//2's complement
module two_s_complement (IN,OUT);
  input signed [7:0] IN;
  output signed [7:0] OUT;

  assign OUT = ~IN + 8'b00000001;
  //assign OUT [7:0] = -IN [7:0];

endmodule //two_s_complement

//2:1 Multiplexer
module mux (OUT,IN1,IN2,SELECT);
  input [7:0] IN1,IN2;
  input SELECT;
  output reg [7:0] OUT;

  always @ (IN1,IN2,SELECT) begin
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
  output reg [31:0] Read_addr;

  always @ (negedge clk) begin
    case (reset)
      0: Read_addr=Read_addr+3'b100;
      1: Read_addr=0;
      default: Read_addr=Read_addr;
    endcase
  end

endmodule // PC


//Control Unit
module CU (instruction, OUT1addr, OUT2addr, INaddr, select, as_MUX, im_MUX, Im_val);
  input [31:0] instruction; //instruction
  output [2:0] OUT1addr;  //Destination Address
  output [2:0] OUT2addr;  //Destination Address
  output [2:0] select;  //ALU select
  output [2:0] INaddr;  //Destination Address
  output [7:0] Im_val;  //Immediate Value
  output as_MUX,im_MUX; //2:1 MUX for add and sub, immediate values

  reg [2:0] OUT1addr,OUT2addr,INaddr,select;
  reg [7:0] Im_val;
  reg as_MUX,im_MUX;

  reg ADD,SUB,LOADI,MOV,AND,OR;

  always @ (instruction) begin
    LOADI <= 8'b00000000;
    ADD   <= 8'b00000001;
    AND   <= 8'b00000010;
    OR    <= 8'b00000011;
    MOV   <= 8'b00001000;
    SUB   <= 8'b00001001;
  end


  always @ (instruction) begin
  case(instruction[31:24])

    //immediate load instructuion
    LOADI : begin
      select = instruction[26:24];
      Im_val = instruction[7:0];
      as_MUX = 1'b0;
      im_MUX = 1'b0;
      OUT1addr = instruction[2:0];
      OUT2addr = instruction[10:8];
      INaddr = instruction[18:16];
    end

    //mov instructuion
    MOV : begin
      select = instruction[26:24];
      Im_val = instruction[7:0];
      as_MUX = 1'b0;
      im_MUX = 1'b1;
      OUT1addr = instruction[2:0];
      OUT2addr = instruction[10:8];
      INaddr = instruction[18:16];
    end

    //add instructuion
    ADD : begin
      select = instruction[26:24];
      Im_val = instruction[7:0];
      as_MUX = 1'b0;
      im_MUX = 1'b1;
      OUT1addr = instruction[2:0];
      OUT2addr = instruction[10:8];
      INaddr = instruction[18:16];
    end

    //sub instructuion
    SUB : begin
      select = instruction[26:24];
      Im_val = instruction[7:0];
      as_MUX = 1'b1;
      im_MUX = 1'b1;
      OUT1addr = instruction[2:0];
      OUT2addr = instruction[10:8];
      INaddr = instruction[18:16];
    end

    //and instructuion
    AND : begin
      select = instruction[26:24];
      Im_val = instruction[7:0];
      as_MUX = 1'b0;
      im_MUX = 1'b1;
      OUT1addr = instruction[2:0];
      OUT2addr = instruction[10:8];
      INaddr = instruction[18:16];
    end

    //or instructuion
    OR : begin
      select = instruction[26:24];
      Im_val = instruction[7:0];
      as_MUX = 1'b0;
      im_MUX = 1'b1;
      OUT1addr = instruction[2:0];
      OUT2addr = instruction[10:8];
      INaddr = instruction[18:16];
    end

    endcase

  end

endmodule // CU

//IR
module Instruction_reg (clk,Read_Addr,instruction);
  input clk;
  input [31:0] Read_Addr;
  output [31:0] instruction;
  reg instruction;

  always @(negedge clk)
  begin
    instruction = Read_Addr;
  end

endmodule // Instruction_reg

module test;

	reg [31:0] Read_Addr;
	reg clk;
	wire [7:0] Result;

	wire [31:0] instruction;
	wire [2:0] OUT1addr,OUT2addr,INaddr,Select;
	wire  [7:0] Imm,OUT1,OUT2,OUTPUT,INPUT,cmp;
	wire [7:0] imValueMUXout, addSubMUXout;
	wire addSubMUX, imValueMUX;


	Instruction_reg ir1(clk, Read_Addr, instruction);
	CU cu1( instruction, OUT1addr, OUT2addr, INaddr, Select, addSubMUX, imValueMUX, Imm);
	regfile8x8a rf1( clk, INaddr, Result, OUT1addr, OUT1, OUT2addr, OUT2 );
	two_s_complement cmp1( OUTPUT, OUT1 );
	mux mux1( addSubMUXout, OUT1, OUTPUT, addSubMUX );
	mux mux2( imValueMUXout, Imm, addSubMUXout, imValueMUX );
	alu al1( Result, imValueMUXout, OUT2, Select );


initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin

	// Operation set 1
	$display("\nOperation      Binary   | Decimal");
	$display("---------------------------------");

	Read_Addr = 32'b0000000000000100xxxxxxxx11111111;//loadi 4,X,0xFF
#40
    $display("load v1        %b | %d",Result,Result);

	Read_Addr = 32'b0000000000000110xxxxxxxx10101010;//loadi 6,X,0xAA
#40
    $display("load v2        %b | %d",Result,Result);

	Read_Addr = 32'b0000000000000011xxxxxxxx10111011;//loadi 3,X,0xBB
#40
	$display("load v3        %b | %d",Result,Result);

	Read_Addr = 32'b00000001000001010000011000000011;//add 5,6,3
#40
    $display("add v4 (v2+v3) %b | %d	(Here it's overflow)",Result,Result);

	Read_Addr = 32'b00000010000000010000010000000101;//and 1,4,5
#40
    $display("and v5 (v1,v4) %b | %d",Result,Result);

	Read_Addr = 32'b00000011000000100000000100000110;//or 2,1,6
#40
    $display("or v6 (v5,v2)  %b | %d",Result,Result);

	Read_Addr = 32'b0000100000001111xxxxxxxx00000010;//mov 7,X,2
#40
    $display("copy v7 (v6)   %b | %d",Result,Result);

	Read_Addr = 32'b00001001000001000000111100000011;//sub 4,7,3
#40
    $display("sub v8 (v7-v3) %b | %d",Result,Result);

// Operation set 2

$display("\nOperation      Binary   | Decimal");
	$display("---------------------------------");

	Read_Addr = 32'b0000000000000100xxxxxxxx00001101;//loadi 4,X,0xFF
#40
    $display("load v1        %b | %d",Result,Result);

	Read_Addr = 32'b0000000000000110xxxxxxxx00101101;//loadi 6,X,0xAA
#40
    $display("load v2        %b | %d",Result,Result);

	Read_Addr = 32'b0000000000000011xxxxxxxx00100001;//loadi 3,X,0xBB
#40
   $display("load v3        %b | %d",Result,Result);

	Read_Addr = 32'b00000001000001010000011000000011;//add 5,6,3
#40
    $display("add v4 (v2+v3) %b | %d",Result,Result);

	Read_Addr = 32'b00000010000000010000010000000101;//and 1,4,5
#40
    $display("and v5 (v1,v4) %b | %d",Result,Result);

	Read_Addr = 32'b00000011000000100000000100000110;//or 2,1,6
#40
    $display("or v6 (v5,v2)  %b | %d",Result,Result);

	Read_Addr = 32'b0000100000001111xxxxxxxx00000010;//mov 7,X,2
#40
    $display("copy v7 (v6)   %b | %d",Result,Result);

   	Read_Addr = 32'b00001001000001000000111100000011;//sub 4,7,3
#40
    $display("sub v8 (v7-v3) %b | %d",Result,Result);

    $finish;
end
endmodule

/*
  ____TEST-BENCHES_____
*/
// module testbench_for_two_s;
//   reg [7:0] IN;
//   wire [7:0] OUT;
//
//   two_s_complement ts(IN,OUT);
//
//   initial begin
//     IN=8'b00000010;
//     #1 $display ("2s complement of %d is %d.",IN,OUT);
//   end
// endmodule // testbench_for_two_s
//
// module testbench_for_mux;
//   reg [7:0] IN1,IN2;
//   wire [7:0] OUT;
//   reg SELECT,clk;
//
//   initial begin
//   //initial values
//     clk=0;
//     SELECT=0;
//     IN1=5;
//     IN2=10;
//
//   //time=3
//     #3 $display ("OUT = %d",OUT);
//   //time=6
//     #6 $display ("OUT = %d",OUT);
//   //time=9
//     #9 SELECT=1;
//     #9 $display ("OUT = %d",OUT);
//   //time=12
//     #12 $display ("OUT = %d",OUT);
//     $finish;
//   end
//
//   // Clock generator
//   always begin
//     #5 clk = ~clk; // Toggle clock every 5 ticks
//   end
//
//   mux two_to_one_mux(IN1,IN2,SELECT,OUT,clk);
//
// endmodule // testbench_for_mux
//
// module testbench_for_PC;
//   reg reset,clk;
//   wire [31:0] Read_addr;
//
//   initial begin
//   //initial values
//     reset=0;
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
