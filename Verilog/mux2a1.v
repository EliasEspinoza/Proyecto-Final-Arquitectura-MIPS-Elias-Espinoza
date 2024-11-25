`timescale 1ns/1ns

module mux2a1 (
	input switch,
	input[31:0] a,
	input[31:0] b,
	output reg[31:0] c
);

always @(*) begin
	if(switch) begin
		c = a;
	end else begin
		c = b;
	end
end

endmodule

module mux2a1_5bits (
	input switch5Bits,
	input[4:0] a,
	input[4:0] b,
	output reg[4:0] c
);

always @(*) begin
	if(switch5Bits) begin
		c = a;
	end else begin
		c = b;
	end
end

endmodule


