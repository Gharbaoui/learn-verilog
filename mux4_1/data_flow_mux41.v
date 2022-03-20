/*data flow modeling of 4 to 1 mux*/


module mux41 (
	input w0, w1, w2, w3, s0, s1,
	output out
);

	assign out = s1 ? (s0 ? w3 : w2)  : (s0 ? w1: w0);
endmodule
