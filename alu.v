module alu(
    input [31:0] a, b,
    input [2:0] f,
    output  [31:0] result,
    output zero,
    output overflow,
    output carry,
    output negative
);
reg[32:0] subPath;
reg[31:0] aluOut;
reg[31:0] sum;
assign result = aluOut;
reg over_reg;
assign overflow = over_reg;
reg carry_reg;
assign carry = carry_reg;
assign negative = aluOut[31];
reg z;

always @* begin
  z = 1'b0;
  case(f[0])
    1'b0:subPath = b;
    1'b1:subPath = ~b;
  endcase
  {carry_reg,sum} = a + subPath + f[0];
  carry_reg = (carry_reg ^ f[0]);
  over_reg = ~(b[31] ^ f[0] ^ a[31]) & (sum[31] ^ a[31]) & ~ (f[1]);
  
  case(f) 
    3'b000:aluOut = sum;
    3'b001:aluOut = sum;
    3'b010:aluOut = a & b;
    3'b011:aluOut = a | b;
    3'b101:aluOut = over_reg ^ sum[31];
    default:aluOut = 32'b0;
  endcase
  if(aluOut == 32'b0) begin
    z = 1'b1;
  end
end
assign zero = z;
endmodule
