`timescale 1ns/1ns

module instructionMemory (
	input[31:0] dirLec,
	output reg[31:0] instruction
);

reg[31:0] memoria[0:63];

initial begin
	$readmemb("instrucciones.txt", memoria);
end

always @(*) begin
	instruction = memoria[dirLec];
end

endmodule

