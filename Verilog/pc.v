module pc (
    input clk,
    input [31:0] pcIn,
    output reg[31:0] pcOut
);

initial begin 
	pcOut = 32'd0;
end
	

always @(posedge clk) begin
	pcOut = (pcIn) ? pcIn: 32'd0;
end

endmodule