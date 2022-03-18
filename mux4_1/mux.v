module mux4_1(out, w0, w1, w2, w3, s0, s1);
	output out;
	input w0, w1, w2, w3, s0, s1;
	wire s0not, s1not, pw0, pw1, pw2, pw3;

	not (s0not, s0), (s1not, s1);
	and (pw0, s0not, w0);
	and (pw1, s0, w1);
	and (pw2, s0not, w2);
	and (pw3, s0, w3);
	wire f0, f1, o0, o1;

	or (f0, pw0, pw1);
	or (f1, pw2, pw3);

	and (o0, f0, s1not);
	and (o1, f1, s1);
	
	or (out, o1, o0);
endmodule
