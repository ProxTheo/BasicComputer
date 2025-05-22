module my_controller (
	input clk, n_alu, z_alu, e_alu, ovf_alu, FGI,
	input [15:0] out_DR,
	input	[15:0] out_IR,
	//IR bits
	output [2:0] alu_op_bits, select_bus,
	output rst_AR, rst_DR, rst_PC, rst_TR, rst_IR, rst_AC, rst_e,
	output enable_AR, enable_DR, enable_PC, enable_TR, enable_IR, enable_AC, enable_mem, enable_e,
	output incr_AR, incr_DR, incr_PC, incr_TR, incr_IR, incr_AC, incr_e
);

wire [2:0] out_timing;
wire I;
wire r,p,indir;
wire S, IEN;
wire R, incr_R;

assign incr_R = (~T0&&~T1&&~T2)&&IEN&&FGI;

my_register #(.W(1)) IEN_reg(.clk(clk), .DATA(0), .w_enable(0), .incr(p&&out_IR[7]), .reset((p&&out_IR[6])||(R&&T2)), .A(IEN));
my_register #(.W(1)) R_reg(.clk(clk), .DATA(0), .w_enable(0), .incr(incr_R), .reset(R&&T2), .A(R));
my_register #(.W(1)) S_reg(.clk(clk), .DATA(0), .w_enable(0), .incr(r&&out_IR[0]), .reset(0), .A(S));
my_register #(.W(3)) timing_counter(.clk(clk), .DATA(3'b111), .w_enable(S), .incr(1'b1), .reset(reset_timer), .A(out_timing));
my_register #(.W(1)) I_reg(.clk(clk), .DATA(out_IR[15]), .w_enable(~R&&T2), .incr(0), .reset(0), .A(I));

assign select_bus = {S2,S1,S0};

// IR bits 
assign T0 = ~|out_timing;
assign T1 = ~out_timing[2] && ~out_timing[1] && out_timing[0];
assign T2 = ~out_timing[2] && out_timing[1] && ~out_timing[0];
assign T3 = ~out_timing[2] && out_timing[1] && out_timing[0];
assign T4 = out_timing[2] && ~out_timing[1] && ~out_timing[0];
assign T5 = out_timing[2] && ~out_timing[1] && out_timing[0];
assign T6 = out_timing[2] && out_timing[1] && ~out_timing[0];
assign T7 = &out_timing;

assign D0 = ~out_IR[14] && ~out_IR[13] && ~out_IR[12];
assign D1 = ~out_IR[14] && ~out_IR[13] && out_IR[12];
assign D2 = ~out_IR[14] && out_IR[13] && ~out_IR[12];
assign D3 = ~out_IR[14] && out_IR[13] && out_IR[12];
assign D4 = out_IR[14] && ~out_IR[13] && ~out_IR[12];
assign D5 = out_IR[14] && ~out_IR[13] && out_IR[12];
assign D6 = out_IR[14] && out_IR[13] && ~out_IR[12];
assign D7 = out_IR[14] && out_IR[13] && out_IR[12];


assign alu_op_bits[0] = (D0&&T5) || (r&&out_IR[9]) || (r&&out_IR[6]);
assign alu_op_bits[1] = (D2&&T5) || (r&&out_IR[9]);
assign alu_op_bits[2] = (r&&out_IR[7]) || (r&&out_IR[6]);
 
assign indir = ~D7 && I && T3; 
assign r = D7 && ~I && T3;
assign p = D7 && I && T3;

assign reset_timer = (D0&&T5) || (D1&&T5) || (D2&&T5) || (D3&&T4) || (D4&&T4) || (D5&&T5) || (D6&&T6) || r || p || (R&&T2);

assign S0 = (~R&&T1) || (~R&&T2) ||(D0&&T4) || (D1&&T4) || (D2&&T4) || (D4&&T4) || (D5&&T5) || (D6&&T4) || (D6&&T6) || indir;
assign S1 = (R&&T0) || (R&&T1) || (~R&&T0) || (~R&&T1) || (D0&&T4) || (D1&&T4) || (D2&&T4) || (D5&&T4) || (D6&&T4) || (D6&&T6) || indir;
assign S2 = (R&&T1) || (~R&&T1) || (~R&&T2) || (D0&&T4) || (D1&&T4) || (D2&&T4) || (D3&&T4) || (D6&&T4) || indir;

assign enable_AR = (~R&&T0) || (~R&&T2) || indir;
assign rst_AR = (R&&T0);
assign incr_AR = (D5&&T4);

assign enable_PC = (D4&&T4) || (D5&&T5);
assign rst_PC = (R&&T1);
assign incr_PC = (R&&T2) || (~R&&T1) || (D6&&T6&&(~(|out_DR))) || (r&&out_IR[4]&& ~n_alu) || (r&&out_IR[3]&&n_alu) || (r&&out_IR[2]&&z_alu) || (r&&out_IR[1]&&~e_alu);

assign enable_IR = (~R&&T1);
assign rst_IR = 0;
assign incr_IR = 0;

assign enable_DR = (D0&&T4) || (D1&&T4) || (D2&&T4) || (D6&&T4);
assign rst_DR = 0;
assign incr_DR = (D6&&T5);

assign enable_AC = (D0&&T5) || (D1&&T5) || (D2&&T5) || (r&&out_IR[9]) || (r&&out_IR[7]) || (r&&out_IR[6]);
assign rst_AC = (r&&out_IR[11]);
assign incr_AC = (r&&out_IR[5]);

assign enable_TR =(R&&T0);
assign rst_TR = 0;
assign incr_TR = 0;

assign enable_mem = (D3&&T4) || (D5&&T4) || (D6&&T6) || (R&&T1);

assign enable_e = (D1&&T5) || (r&&out_IR[7]) || (r&&out_IR[6]);
assign rst_e = (r&&out_IR[10]);
assign incr_e = (r&&out_IR[8]);


endmodule