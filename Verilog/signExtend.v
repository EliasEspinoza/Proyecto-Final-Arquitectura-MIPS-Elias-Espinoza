`timescale 1ns/1ns

module signExtend (
	input[15:0] in,
	output reg[31:0] out
);


always @(*) begin
	if (in[15] == 1'b0) begin
		out = {16'b0000000000000000, in};
	end else begin
		out = {16'b1111111111111111, in};
	end
end


endmodule
