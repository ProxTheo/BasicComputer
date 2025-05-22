module my_register #(parameter W = 16) (
	input [W-1:0] DATA,
	output reg [W-1:0] A,
	input incr, w_enable, reset, clk
);

initial begin
	A <= {W{1'b0}};
end


always @(posedge clk) begin

	if (reset) begin 
		A <= 0;
	end else if (w_enable) begin
		A <= DATA;
	end else if (incr) begin
		A <= A + 1;
	end else begin
		A <= A;
	end
	
end

endmodule