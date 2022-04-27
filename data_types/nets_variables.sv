module Nets();
	wire a; // used to connect elements single wire in this case
	wire [3:0] bus; // represent 4 wires that can be controlled spreatly
endmodule


module Vars();
	// this data type can hold data (data storage element)
	reg[7:0] store; // you could think of this type as register
endmodule

module OtherTypes();
	integer count; // this is 32bit variable
	time	end_time; // is 64bit variable and can be used for time simulation
	real	fl; // can be used to store floating point values
endmodule

module Test();
	integer int_a;
	real	real_b;
	time	time_c;
	reg [8*5:1]	str;
	initial
		begin
			str = "Hello";
			int_a = 32'had45_78ff;
			real_b = 0.8751;
#20
			time_c = $time;

			$display("integer = 0x%0h", int_a);
			$display("real_b = %0.5f", real_b);
			$display("time = %0t", time_c);
			$display("str = %s", str);
		end
endmodule
