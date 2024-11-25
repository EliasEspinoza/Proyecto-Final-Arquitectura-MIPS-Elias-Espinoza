`timescale 1ns/1ns

module unitControl(
	input[5:0] op, //Para tipo r siempre sera 000000
	output reg[2:0] aluSel, //ALUOp
	output reg wEnMemoria1, //regWrite
	output reg wEnMemoria2, // memWrite
	output reg rEnMemoria2, // memRead
	output reg mux, // memToReg
	output reg registroInstruccion, //RegDst
	output reg branch, //Branch
	output reg aluSrc //ALUSrc
);

/*
Codigos binario op de operaciones tipo R
000000
Codigos binario op de operaciones tipo I
001000 addi
001101 ori
001100 andi
100011 lw
101011 sw
001010 slti
000100 beq
*/

always @(*) begin 
	case(op)
	6'b000000: //Instruccion tipo R
		begin
			wEnMemoria1 = 1'b1;
			aluSel = 3'b000;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b1;
			branch = 1'b0;
			aluSrc = 1'b0;
		end
	6'b001000: //Intruccion tipo ADDI
		begin
			wEnMemoria1 = 1'b1;
			aluSel = 3'b010;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b0;
			branch = 1'b0;
			aluSrc = 1'b1;
		end
	6'b001101: //Intruccion tipo ORI
		begin
			wEnMemoria1 = 1'b1;
			aluSel = 3'b001;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b0;
			branch = 1'b0;
			aluSrc = 1'b1;
		end
	6'b001100: //Intruccion tipo ANDI
		begin
			wEnMemoria1 = 1'b1;
			aluSel = 3'b011;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b0;
			branch = 1'b0;
			aluSrc = 1'b1;
		end
	6'b001010: //Intruccion tipo SLTI
		begin
			wEnMemoria1 = 1'b1;
			aluSel = 3'b111;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b0;
			branch = 1'b0;
			aluSrc = 1'b1;
		end
	6'b100011: //Intruccion tipo LW
		begin
			wEnMemoria1 = 1'b1;
			aluSel = 3'b010;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b1;
			mux = 1'b1;
			registroInstruccion = 1'b0;
			branch = 1'b0;
			aluSrc = 1'b1;
		end
	6'b101011: //Intruccion tipo SW
		begin
			wEnMemoria1 = 1'b0;
			aluSel = 3'b010;
			wEnMemoria2 = 1'b1;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b0;
			branch = 1'b0;
			aluSrc = 1'b1;
		end
	6'b000100: //Intruccion tipo BEQ
		begin
			wEnMemoria1 = 1'b0;
			aluSel = 3'b110;
			wEnMemoria2 = 1'b0;
			rEnMemoria2 = 1'b0;
			mux = 1'b0;
			registroInstruccion = 1'b0;
			branch = 1'b1;
			aluSrc = 1'b0;
		end	
	endcase
end

endmodule
