module alub_8_bit(oprand1, oprand2, select, zero, out);
	input [7:0]  oprand1;
	input [7:0] oprand2;
	input [2:0] select;
	output reg [7:0] out;
	output reg zero;


	always @ (oprand1, oprand2, select)
	begin
		case (select)
			3'b000: out = oprand2;
			3'b001: out = oprand2 + oprand1;
			3'b010: out = oprand1 & oprand2;
			3'b011: out = oprand2 | oprand1;
			default: out = 8'b00000000;
		endcase
	end

	always @ (out)
	begin
		zero = ~|out;
	end
endmodule
