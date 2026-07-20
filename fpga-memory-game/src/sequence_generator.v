`timescale 1ns / 1ps

module sequence_generator(
	input clk,
	input reset,
	output reg [15:0] sequence  // 16-bit sequence
);

	reg [15:0] random;

	// Pseudo-random generator
	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	random <= 16'b0001_1111_1111_0001; // Initial seed
        	sequence <= 16'b0000_0000_0011_0011; // Base sequence
    	end else begin
        	random <= (random * 4 + 1) / 3; // Update randomvalue
        	sequence <= (16'b0000_0000_0011_0011 + random); // Add randomness to base sequence
    	end
	end
	
endmodule


