//Don't change the module I/O
module BC_I (
input clk,
input FGI,
output [11:0] PC,
output [11:0] AR,
output [15:0] IR,
output [15:0] AC,
output [15:0] DR
);

wire rst_AR, rst_DR, rst_PC, rst_TR, rst_IR, rst_AC, rst_e;
wire enable_AR, enable_DR, enable_PC, enable_TR, enable_IR, enable_AC, enable_mem, enable_e;
wire incr_AR, incr_DR, incr_PC, incr_TR, incr_IR, incr_AC, incr_e;
wire [2:0] alu_op_bits, select_bus;
wire z_alu, n_alu, ovf_alu, e_alu;

my_controller controller(
.clk(clk),
.alu_op_bits(alu_op_bits),
.out_DR(DR), 
.out_IR(IR), 
.rst_AR(rst_AR),
.rst_DR(rst_DR),
.rst_PC(rst_PC),
.rst_TR(rst_TR),
.rst_IR(rst_IR),
.rst_AC(rst_AC),
.rst_e(rst_e),
.enable_AR(enable_AR),
.enable_DR(enable_DR),
.enable_PC(enable_PC),
.enable_TR(enable_TR),
.enable_IR(enable_IR),
.enable_AC(enable_AC),
.enable_mem(enable_mem),
.enable_e(enable_e),
.incr_AR(incr_AR),
.incr_DR(incr_DR),
.incr_PC(incr_PC),
.incr_TR(incr_TR),
.incr_IR(incr_IR),
.incr_AC(incr_AC),
.incr_e(incr_e),
.select_bus(select_bus),
.z_alu(z_alu),
.n_alu(n_alu),
.ovf_alu(ovf_alu),
.e_alu(e_alu),
.FGI(FGI)
);

my_datapath datapath(
.clk(clk),
.alu_op(alu_op_bits),
.out_DR(DR),
.out_IR(IR),
.out_PC(PC),
.out_AR(AR),
.out_AC(AC),
.rst_AR(rst_AR),
.rst_DR(rst_DR),
.rst_PC(rst_PC),
.rst_TR(rst_TR),
.rst_IR(rst_IR),
.rst_AC(rst_AC),
.rst_e(rst_e),
.enable_AR(enable_AR),
.enable_DR(enable_DR),
.enable_PC(enable_PC),
.enable_TR(enable_TR),
.enable_IR(enable_IR),
.enable_AC(enable_AC),
.enable_mem(enable_mem),
.enable_e(enable_e),
.incr_AR(incr_AR),
.incr_DR(incr_DR),
.incr_PC(incr_PC),
.incr_TR(incr_TR),
.incr_IR(incr_IR),
.incr_AC(incr_AC),
.incr_e(incr_e),
.select_bus(select_bus),
.z_alu(z_alu),
.n_alu(n_alu),
.ovf_alu(ovf_alu),
.e_alu(e_alu)
);


// Instantiate your datapath and controller here, then connect them.
endmodule