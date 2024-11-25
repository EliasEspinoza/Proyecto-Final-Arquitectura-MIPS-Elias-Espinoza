`timescale 1ns/1ns

module setOnLessThan (
	input[31:0] D,
	input[31:0] E,
	output reg[31:0] S5
);

always@(*)begin
	if(D < E) begin
		S5 = 32'b1;
	end else begin
		S5 = 32'b0;
	end
end
endmodule

module ALU (
	input[31:0] operand1,
	input[31:0] operand2,
	input[2:0] sel,
	output reg[31:0] resultado,
	output reg zf
);

wire[31:0] slt;

setOnLessThan I1(.D(operand1),.E(operand2),.S5(slt));

always@(*) begin
	case (sel)
	3'b000: resultado = operand1 & operand2; //and
	3'b001: resultado = operand1 | operand2; //or
	3'b010: resultado = operand1 + operand2; //add
	3'b110: resultado = operand1 - operand2; //sub
	3'b111: resultado = slt; //slt
	default: resultado = 32'd0;
	endcase
end

always@(*) begin
	if(resultado == 32'b0) begin
		zf = 1'b1;
	end
end

always@(*) begin
	if(resultado != 32'b0) begin
		zf = 1'b0;
	end
end

endmodule
