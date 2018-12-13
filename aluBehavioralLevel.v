/*  op-code = 8 bit
    dest    = 8 bit
    src1    = 8 bit
    src 2   = 8 bit
    control = 3 bit
    https://vlsicoding.blogspot.com/2013/10/design-4-bit-alu-in-verilog.html
*/

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