module mux41(w0, w1, w2, w3, s0, s1, out);
	input wire w0, w1, w2, w3, s0, s1;
	output reg out;
	always @ (w0 or w1 or w2 or w3 or s0 or s1)
		begin
			if (s1)
				begin
					if (s0)
						out <= w3;
					else
						out <= w2;
				end
			else
				begin
					if (s0)
						out <= w1;
					else
						out <= w0;
				end
		end
endmodule
