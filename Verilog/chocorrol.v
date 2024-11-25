`timescale 1ns/1ns

module chocorrol (
	input clkIn
);

//Cables memoria1 Banco de registros
wire[31:0] dato1_toAluOperando1, dato2_toAluOperando2;
//Cables memoria2 memoria Ram
wire[31:0] datoOutMemoria2;
//Cables alu
wire[31:0] resultadoAlu;
wire zeroFlag;
//Cables control alu
wire[2:0] controlAlu_toAlu;
//Cables unidad de control
wire[2:0] unitControl_toControlAlu;
wire wEn_toMemoria1, wEn_toMemoria2, rEn_toMemoria2, UC_switchMux;
wire registroDestino, branchToAND, ALUSrcToMux;
//Cables mux 2a1 memoria Ram o Alu a BR
wire[31:0] mux_toMemoria1;
//Cables mux de instrucciones
wire[4:0] writeRegister;
//Cables pc
wire[31:0] wPcOut;
//Cables memoria de instrucciones
wire[31:0] instruccion;
//Cables de add con compuerta AND antes
wire[31:0] toPcIn;
//Cables add de 4
wire[31:0] result;
//Cables de add alu result
wire[31:0] addToMux;
//Cable resultado de la AND
wire andResult;
//Cables del multiplexor entre el BR y la ALU
wire[31:0] muxToAlu_Operand2;
// Cables de SignExtend
wire [31:0] senialExtendida;
//Cables de ShiftLeft2
wire[31:0] numeroRecorrido;


unitControl instUnitControl(
	.op(instruccion[31:26]),
	.aluSel(unitControl_toControlAlu),
	.wEnMemoria1(wEn_toMemoria1),
	.wEnMemoria2(wEn_toMemoria2),
	.rEnMemoria2(rEn_toMemoria2),
	.mux(UC_switchMux),
	.registroInstruccion(registroDestino),
	.branch(branchToAND),
	.aluSrc(ALUSrcToMux)
);
				
controlAlu instControlAlu(
	.funct(instruccion[5:0]),
	.unitControl(unitControl_toControlAlu),
	.aluSel(controlAlu_toAlu)
);
				
bancoRegistros instBancoRegistros(
	.datoIn(mux_toMemoria1),
	.dirLec1(instruccion[25:21]),
	.dirLec2(instruccion[20:16]),
	.dirEsc(writeRegister),
	.wEnable(wEn_toMemoria1),
	.dato1(dato1_toAluOperando1),
	.dato2(dato2_toAluOperando2)
);
			
ALU instAlu(
	.operand1(dato1_toAluOperando1),
	.operand2(muxToAlu_Operand2),
	.sel(controlAlu_toAlu),
	.resultado(resultadoAlu),
	.zf(zeroFlag)
);
		

memoriaRam instMemoriaRam(
	.dato(dato2_toAluOperando2),
	.dir(resultadoAlu),
	.wEnable(wEn_toMemoria2),
	.rEnable(rEn_toMemoria2),
	.datoOut(datoOutMemoria2)
);

			
mux2a1 instM_AluORam( //Mux que envia resultado de alu o dato de memoria
	.switch(UC_switchMux),
	.a(datoOutMemoria2),
	.b(resultadoAlu),
	.c(mux_toMemoria1)
);

mux2a1 instM_2ALU( //Mux que envia resultado de sumador de señal extendida o pc + 4
	.switch(andResult),
	.a(addToMux),
	.b(result),
	.c(toPcIn)
);

mux2a1_5bits instM_Instrucciones( //Mux que decide rango de instrucciones
	.switch5Bits(registroDestino),
	.a(instruccion[15:11]),
	.b(instruccion[20:16]),
	.c(writeRegister)
);

mux2a1 instM_BR_toALU( //Mux que envia dato 2 de BR o señal extendida
	.switch(ALUSrcToMux),
	.a(senialExtendida),
	.b(dato2_toAluOperando2), 
	.c(muxToAlu_Operand2)
);

ADD instADD_senialExtendida(
	.operand1(result),
	.operand2(numeroRecorrido),
	.resultado(addToMux)
);

ADD instADD4(
	.operand1(wPcOut),
	.operand2(32'd4),
	.resultado(result)
);


signExtend instSignExtend(
	.in(instruccion[15:0]),
	.out(senialExtendida)
);



shiftLeft2 instShiftLeft2(
	.in(senialExtendida),
	.out(numeroRecorrido)
);


instructionMemory instInstructionMemory(
	.dirLec(wPcOut),
	.instruction(instruccion)
);


pc instPC (
	.pcIn(toPcIn),
	.clk(clkIn),
	.pcOut(wPcOut)
);

C_AND instAND(
	.a(branchToAND),
	.b(zeroFlag),
	.c(andResult)
);

endmodule
