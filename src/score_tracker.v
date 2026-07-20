`timescale 1ns / 1ps

module score_tracker (
	input clk,
	input reset,
	input correct,     	// High when sequence is correct
	output reg [3:0] score // Current score (max 9)
);

	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	score <= 0; // Reset score
    	end else if (correct) begin
        	if (score < 9) begin
            	score <= score + 1; // Increment score on correct input
        	end
    	end
	end
endmodule