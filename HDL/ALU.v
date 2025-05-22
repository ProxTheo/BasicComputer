module ALU #(parameter W = 4) (
	input [W-1:0] AC, DR, 
	input E,
	input [2:0] OP,
	output reg [W-1:0] result,
	output reg CO,
	output OVF, N, Z
	
);

localparam ADD = 0;
localparam AND = 1;
localparam TRANSFER = 2;
localparam COMP = 3;
localparam SHR = 4;
localparam SHL = 5;


assign Z = ~|AC;
assign N = AC[W-1]; 
assign OVF = (~|OP) && ((AC[W-1] && DR[W-1] && ~N) || (~AC[W-1] && ~DR[W-1] && N));


always @(*) begin
	case (OP)
		ADD: 		 {CO,result} <= AC + DR;
		AND: 		 begin
						result <= AC & DR;
						CO <= 0;
					end
		TRANSFER: begin
						result <= DR;
						CO <= 0;
					end
		COMP:     begin
						result <= ~AC;
						CO <= 0;
					end
		SHR:      begin
						result <= {E,AC[W-1:1]};
						CO <= AC[0];
					end
		SHL:      begin
						result <= {AC[W-2:0],E};
						CO <= AC[W-1];
					end
		default:  begin
						result <= 0;
						CO <= 0;
					 end
	endcase
end
endmodule