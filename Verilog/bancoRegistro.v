`timescale 1ns/1ns

module bancoRegistros (
	input[31:0] datoIn,
	input[4:0] dirLec1,
	input[4:0] dirLec2,
	input[4:0] dirEsc,
	input wEnable,
	output reg[31:0] dato1,
	output reg[31:0] dato2
);

reg[31:0] Memoria[0:63];

initial begin
	$readmemb("bancoRegistroDatos.txt",Memoria);
	#10;
end

always@(*)
begin
	if(wEnable) begin
		Memoria[dirEsc] = datoIn;
	end	
end

always@(*)
begin
	dato1 = Memoria[dirLec1];
	dato2 = Memoria[dirLec2];	
end 

endmodule


