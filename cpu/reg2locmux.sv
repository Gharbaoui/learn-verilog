/*******************************************************
this multiplxor will decide where are the inputs that represent register number 2 to be supplied to register file
r_type_pos 26:16
str_load_cbz 4:0
if sel is 0
	choose r_type_pos 
else
	choos str_load_cbz 
*******************************************************/


module reg2locmux(r_type_pos, str_load_cbz, sel, out);
	input wire[4:0] r_type_pos, str_load_cbz;
	input wire sel;
	output wire[4:0] out;

	assign out = sel ? str_load_cbz : r_type_pos;
endmodule

module tb_reg2locmux;
	reg[4:0] r_pos, str_pos;
	wire[4:0] out;
	reg sel;

	reg2locmux u0(
		.r_type_pos (r_pos),
		.str_load_cbz(str_pos),
		.sel(sel),
		.out(out)
	);

	initial begin
		r_pos = 5'b00000;
		str_pos = 5'b11111;
		sel = 0;
		#10;
		$display("r_pos = %b, str_pos %b sel = %b, out = %b", r_pos, str_pos, sel, out);
		sel = 1;
		#10;
		$display("r_pos = %b, str_pos %b sel = %b, out = %b", r_pos, str_pos, sel, out);
	end

endmodule
