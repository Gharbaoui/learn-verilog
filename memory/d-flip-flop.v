module d_filp_flop(d, we, clk, q);
	input d, we, clk;
	output reg q;
	
	always @  (posedge clk)
	begin
		if (we)
			q <= d;
	end
endmodule
