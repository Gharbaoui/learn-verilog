/************************************************************************
scaler and vector are just terms that are used to say is type 1 bit scalar or multibit vector
************************************************************************/

module scalarAndVector();
	wire a; // scalar
	wire[3:0] b; // vector
	reg c;  // scalar
	reg[7:0] d; // vector
	integer i;

	reg[31:0] num;
	// part selects
		// constant part select
	// indexed part select
	initial
	begin
	num[15:8] = 8'h45; // bits 15-8 will be replaces by value 0x45
	// bit select // it's like index in any other language
	d[0] = 0;
	d[5] = 1;

		num = 32'haa45_fa78;
		for (i = 0; i < 4; ++i) begin
		  	$display("num[8*%0d +: 8] = 0x%0h", i, num[8*i +: 8]);
		  end
			
	end



endmodule
