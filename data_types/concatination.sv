module test;

	wire a, b;
	wire [1:0] res;

	wire [3:0] c;
	wire [7:0] res1;

	assign res = {a, b}; // res[1] = a; res[0] = b


	assign res1 = {b, a, c[1: 0], 2'b00, c[2]};


	// replication operator
	wire [6:0] res2;

	assign res2 = {7{a}};
endmodule
