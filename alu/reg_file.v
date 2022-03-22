module reg_file(radr1, radr2, wadr, wd, we, clk, reset, out1, out2);
	input	[2:0] radr2;
	input	[2:0] radr1;
	input	[2:0] wadr;
	input	[7:0] wd;
	input reset;
	input clk;
	input we;
	output reg [7:0] out1;
	output reg [7:0] out2;


	integer i;
	reg [7:0] regFile [0:7];
	always @ (*)
	if (reset)
	begin
		for (i = 0; i < 8; i = i + 1)
		begin
			regFile[i] = 8'b00000000;
		end
	end
	always @ (posedge clk)
	begin
		if (we == 1'b1 && reset == 1'b0)
		begin
			regFile[wadr] = wd;
		end
	end
	assign ou1 = regFile[radr1];
	assign ou2 = regFile[radr2];
endmodule

