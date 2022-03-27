module shifter_8bit(dir, clk, reset, data, out);
	// if dir is 1 means shift right otherwise shift left
	input dir;
	input clk;
	input reset;
	input [7:0] data;
	output reg [7:0] out;

	always @ (posedge clk , reset)
	begin
		if (reset)
		  out <= 8'b00000000;
		else
		  begin
		  	if (dir == 1'b1)
			  out = {1'b0, data[7:1]};
			else
			  out = {data[6:0], 1'b0};
		  end
	end
endmodule
