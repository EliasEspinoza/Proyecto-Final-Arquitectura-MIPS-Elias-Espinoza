`timescale 1ns/1ns

module memoriaRam (
	input[31:0] dato,
	input[31:0] dir,
	input wEnable,
	input rEnable,
	output reg[31:0] datoOut
);

reg[31:0] memoria[0:31];

always@(*)
begin
	if(wEnable) begin
	//Escribir
	memoria[dir] = dato;
	end else if(rEnable) begin
	//Leer
	datoOut = memoria[dir];
	end
end 

endmodule
