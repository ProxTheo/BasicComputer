module my_mux_8to1 #(parameter W = 4) (
	input [W-1:0] A0, A1, A2, A3, A4, A5, A6, A7,
	input [2:0] S,
	output reg [W-1:0] Q
); 

always @(*) begin
	case(S)
		3'b000: Q = A0;
		3'b001: Q = A1;
		3'b010: Q = A2;
		3'b011: Q = A3;
		3'b100: Q = A4;
		3'b101: Q = A5;
		3'b110: Q = A6;
		3'b111: Q = A7;
	endcase
end

endmodule
