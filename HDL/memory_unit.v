module memory_unit (
	input [15:0] DATA,
	input clk, w_enable,
	input [11:0] Address,
	output reg [15:0] read_data
);

reg [15:0] memory_block[4096];

initial begin
	memory_block[12'h000] = 16'h400F ; // BUN 00F,  Reserved Interrupt Return Memory
	memory_block[12'h001] = 16'h4005 ; // Branch to Interrupt subroutine
	memory_block[12'h002] = 16'h0000 ;
	memory_block[12'h003] = 16'h0000 ; // AC Storage
	memory_block[12'h004] = 16'h0000 ; // Interrupt Result = 1 
	memory_block[12'h005] = 16'h3003 ; // 0 STA 0x003, Store Old AC #1
	memory_block[12'h006] = 16'h7800 ; // CLA  #2
	memory_block[12'h007] = 16'h7020 ; // INC  #3
	memory_block[12'h008] = 16'h3004 ; // 0 LDA M[0x4] #4
	memory_block[12'h009] = 16'hF080 ; // ION #5
	memory_block[12'h00A] = 16'hC000 ; // 1 BUN 000 #6
	memory_block[12'h00B] = 16'h0000 ;
	memory_block[12'h00C] = 16'h0000 ;
	memory_block[12'h00D] = 16'h0000 ; // Result storage of the main program. Result should be 0x087.
	memory_block[12'h00E] = 16'h0000 ; // Main program starts below, Add 2 number and shift R then store
	memory_block[12'h00F] = 16'hF080 ; // ION 
	memory_block[12'h010] = 16'h2015 ; // 0 LDA M[0x15], AC <= 1
	memory_block[12'h011] = 16'h9016 ; // 1 ADD M[M[16]], AC <= AC + 0x10E, AC = 0x10F #7
	memory_block[12'h012] = 16'h7080 ; // CIR, AC = 0x087, E = 1 #8
	memory_block[12'h013] = 16'h300D ; // 0 STA 0x00D
	memory_block[12'h014] = 16'h401A ; // 0 BUN 01A
 	memory_block[12'h015] = 16'h0001 ;
	memory_block[12'h016] = 16'h0017 ;
	memory_block[12'h017] = 16'h010E ;
	memory_block[12'h018] = 16'h0000 ; // Result storage for interrupt test. Should be 0xF78.
	memory_block[12'h019] = 16'h0000 ; // Interrupt test
	memory_block[12'h01A] = 16'h7200 ; // CMA, AC <= AC', AC = 0xF78 #9
	memory_block[12'h01B] = 16'h3018 ; // 0 STA 0x018  
	memory_block[12'h01C] = 16'h401E ; // 0 BUN 01E
	memory_block[12'h01D] = 16'h0000 ;
	memory_block[12'h01E] = 16'h7001 ; // HLT #10 
	memory_block[12'h01F] = 16'h0000 ;
	memory_block[12'h020] = 16'h0000 ; 
end

always @(posedge clk) begin
	if (w_enable) begin
		memory_block[Address] <= DATA;
	end
end

always @(*) begin
	read_data <= memory_block[Address];
end

endmodule