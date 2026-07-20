`timescale 1ns / 1ps

module sequence_checker(
	input clk,                 	// System clock
	input reset,               	// Reset signal
	input [3:0] user_input,    	// Input from keypad (0-9)
	input valid_input,         	// High when a valid input is detected
	input [15:0] sequence,      // Generated sequence array
	output reg correct,        	// High when the input matches so far
	output reg incorrect      	// High when there's a mismatch
);

	reg game_active; // Flag to indicate if the game is ongoing
	reg [3:0] current_pos;

	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	correct <= 0;
        	incorrect <= 0;
        	current_pos <= 0;
        	game_active <= 1;
    	end else if (game_active && valid_input) begin
        	if (user_input == sequence[4*current_pos +: 4]) begin
            	// Input matches the current sequence position
            	correct <= 1;
            	incorrect <= 0;
            	current_pos <= current_pos + 1;

            	// If this is the last input, reset for the next round
            	if (current_pos + 1 == 4'd16) begin
                	current_pos <= 0;
                	game_active <= 0; // Sequence successfully completed
            	end
        	end else begin
            	// Input mismatch
            	incorrect <= 1;
            	correct <= 0;
            	current_pos <= 0; // Reset sequence position
            	game_active <= 0; // End the game
        	end
    	end else begin
        	// No valid input or game not active
        	correct <= 0;
        	incorrect <= 0;
    	end
	end
endmodule