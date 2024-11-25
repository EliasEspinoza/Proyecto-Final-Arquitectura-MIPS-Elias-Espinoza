`timescale 1ns/1ns

module controlAlu (
	input[5:0] funct,
	input[2:0] unitControl,
	output reg[2:0] aluSel
);
/*
Codigos Binarios funct de Operaciones tipo r 
100000 suma
100010 resta
101010 menor que
100100 and
100101 or
100110 xor
100111 nor
*/



always @(*) begin
	case (unitControl)
		3'b000 : //Instrucciones tipo R
			begin
			case (funct)
				6'b100000: aluSel = 3'b010;	//add
				6'b100010: aluSel = 3'b110;	//sub
				6'b101010: aluSel = 3'b111;	//slt
				6'b100100: aluSel = 3'b000;	//and
				6'b100101: aluSel = 3'b001;	//or
				6'b000000: aluSel = 3'b100;	//nop
			endcase
			end
		3'b010 : //Instrucciones tipo I addi
			begin
			aluSel = 3'b010; //add
			end
		3'b001 : //Instrucciones tipo I ori
			begin
			aluSel = 3'b001; //or
			end
		3'b011 : //Instrucciones tipo I andi
			begin
			aluSel = 3'b000; //and
			end
		3'b111 : //Instrucciones tipo I slti
			begin
			aluSel = 3'b111; //slt
			end
		3'b110 : //Instrucciones tipo I beq
			begin
			aluSel = 3'b110; //resta
			end
	endcase
	
end

endmodule