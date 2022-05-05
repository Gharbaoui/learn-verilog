/**************************************************
will be used to select between immediate and pc input
if sel b passes
else a passes
**************************************************/


module mux32(a, b, sel, out);
	input wire[31:0] a, b;
	input sel;
	output wire[31:0] out;


	assign out = sel ? b : a;
endmodule


module tb_mux32;
	reg[31:0] a, b;
	wire[31:0] out;
	reg sel;

	mux32 u0(
		.a(a),
		.b(b),
		.sel(sel),
		.out(out)
	);

	initial begin
		a = 32'hffffffff;
		b = 32'h00000000;
		sel = 0;
		#10;
		$display("a = %h, b = %h, sel = %b, out = %h", a, b, sel, out);
		sel = 1;
		#10;
		$display("a = %h, b = %h, sel = %b, out = %h", a, b, sel, out);
	end

endmodule
