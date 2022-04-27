module array();
	reg y1[3:0]; // is scalar register with depth of 4
	wire[0:7] y2[3:4]; // is 8-bit vector net with depth of 4
	reg [7:0] y3[0:1][0:3]; // is 2D array of 8-bit register rows 2 cols 4
endmodule
