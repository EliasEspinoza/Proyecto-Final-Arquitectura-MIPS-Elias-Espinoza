`timescale 1ns/1ns

module ADD (
	input[31:0] operand1,
	input[31:0] operand2,
	output [31:0] resultado
);

assign resultado = operand1 + operand2;

endmodule
