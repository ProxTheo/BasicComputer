module my_bus (
	input [15:0] mem_data, AR, PC, DR, AC, IR, TR,
	input [2:0] select,
	output reg [15:0] bus_data
);

	always @(*) begin
		case (select)
			3'b001: bus_data <= AR;
			3'b010: bus_data <= PC;
			3'b011: bus_data <= DR;
			3'b100: bus_data <= AC;
			3'b101: bus_data <= IR;
			3'b110: bus_data <= TR;
			3'b111: bus_data <= mem_data;
			default: bus_data <= 0;
		endcase
	end
	
	
endmodule