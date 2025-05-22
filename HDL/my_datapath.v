module my_datapath (
 input clk,
 input [2:0] alu_op,
 input rst_AR, rst_DR, rst_PC, rst_TR, rst_IR, rst_AC, rst_e,
 input enable_AR, enable_DR, enable_PC, enable_TR, enable_IR, enable_AC, enable_mem, enable_e,
 input incr_AR, incr_DR, incr_PC, incr_TR, incr_IR, incr_AC, incr_e,
 input [2:0] select_bus,
 output [15:0] out_DR, out_IR, out_TR, out_AC,
 output [11:0] out_AR, out_PC,
 output z_alu, n_alu, ovf_alu, e_alu
);

wire [15:0] out_mem, result_alu, bus_data;
wire co_alu;

my_bus b1(.mem_data(out_mem), .select(select_bus), .AR(out_AR), .DR(out_DR), .PC(out_PC), .TR(out_TR), .IR(out_IR), .AC(out_AC), .bus_data(bus_data));

my_register #(.W(12)) AR(.clk(clk), .DATA(bus_data), .A(out_AR), .reset(rst_AR), .w_enable(enable_AR), .incr(incr_AR));
my_register #(.W(16)) DR(.clk(clk), .DATA(bus_data), .A(out_DR), .reset(rst_DR), .w_enable(enable_DR), .incr(incr_DR));
my_register #(.W(12)) PC(.clk(clk), .DATA(bus_data), .A(out_PC), .reset(rst_PC), .w_enable(enable_PC), .incr(incr_PC));
my_register #(.W(16)) TR(.clk(clk), .DATA(bus_data), .A(out_TR), .reset(rst_TR), .w_enable(enable_TR), .incr(incr_TR));
my_register #(.W(16)) IR(.clk(clk), .DATA(bus_data), .A(out_IR), .reset(rst_IR), .w_enable(enable_IR), .incr(incr_IR));
my_register #(.W(16)) AC(.clk(clk), .DATA(result_alu), .A(out_AC), .reset(rst_AC), .w_enable(enable_AC), .incr(incr_AC));

my_register #(.W(1)) E(.clk(clk), .DATA(co_alu), .A(e_alu), .reset(rst_e), .w_enable(enable_e), .incr(incr_e)); 

memory_unit mem1(.clk(clk), .w_enable(enable_mem), .Address(out_AR), .read_data(out_mem), .DATA(bus_data));

ALU #(.W(16)) alu1(.AC(out_AC), .DR(out_DR), .OP(alu_op), .result(result_alu), .CO(co_alu), .OVF(ovf_alu), .N(n_alu), .Z(z_alu), .E(e_alu));

endmodule