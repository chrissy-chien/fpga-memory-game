`timescale 1ns / 1ps

module memory_game(
	input wire clk,
	input wire reset,
	input wire start,             	// Start game
	input wire check,             	// Validate user input
	input wire [3:0] row,         	// Keypad row inputs
	output wire [3:0] col,        	// Keypad column outputs
	output wire [6:0] seg,        	// Seven-segment display segments
	output wire [3:0] an,         	// Seven-segment display anodes
	output reg game_over
);

	// Wires and signals
	wire slow_clk;            	// Clock divider output
	wire valid_input;         	// Keypad valid input signal
	wire [3:0] keypad_value;  	// Keypad decoded value
	wire correct;             	// Sequence correctness signal
	wire [15:0] sequence;     	// Generated sequence
	wire [3:0] digit3, digit4;	// Keypad input digits for display
	wire [3:0] score;         	// Player's score
	wire debounced_start_button;  // Stable start button signal
	wire debounced_check_button;  // Stable check button signal
	reg start_display;        	// Signal to start sequence display
	reg new_sequence;         	// Signal to generate new sequence
	reg new_speed;            	// Signal to adjust speed
	reg [31:0] speed_factor;  	// Speed adjustment factor
	wire incorrect_flag;      	// Sequence incorrectness flag (Changed to wire)

	// Clock Divider
	clock_divider clk_div (
    	.clk(clk),
    	.reset(reset || new_speed),
    	.speed_factor(speed_factor),
    	.slow_clk(slow_clk)
	);

	// Sequence Generator
	sequence_generator seq_gen (
    	.clk(clk),
    	.reset(reset || new_sequence),
    	.sequence(sequence)
	);

	// Instantiate the Keypad Module
	wire [3:0] keypad_digit3;
	wire [3:0] keypad_digit4;
	keypad keypad_inst (
    	.clk(clk),
    	.reset(reset),
    	.row(row),
    	.col(col),
    	.valid_input(valid_input),
    	.keypad_value(keypad_value),
    	.digit3(keypad_digit3),
    	.digit4(keypad_digit4)
	);

	// Sequence Checker
	sequence_checker seq_check (
    	.clk(clk),
    	.reset(reset),
    	.user_input(keypad_value),
    	.valid_input(valid_input),
    	.sequence(sequence),
    	.correct(correct),
    	.incorrect(incorrect_flag)
	);

	// Score Tracker
	score_tracker score_mod (
    	.clk(clk),
    	.reset(reset),
    	.correct(correct),
    	.score(score)
	);

	// Seven-Segment Display
	seven_segment_display seg_disp (
    	.clk(slow_clk),       	// Use slower clock for multiplexing
    	.reset(reset),
    	.score(score),
    	.digit3(keypad_digit3),
    	.digit4(keypad_digit4),
    	.segment(seg),
    	.anode(an)
	);

	// Debouncer for Start Button
	debouncer debounce_start (
    	.clk(clk),
    	.reset(reset),
    	.button_input(start),    
    	.debounced_output(debounced_start_button)
	);

	// Debouncer for Check Button
	debouncer debounce_check (
    	.clk(clk),
    	.reset(reset),
    	.button_input(check),    
    	.debounced_output(debounced_check_button)
	);

	// Game State Management
	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	start_display <= 1'b1;
        	new_sequence <= 1'b1;
        	new_speed <= 1'b1;
        	speed_factor <= 32'd1_000_000; // Initial speed factor (~10ms)
        	game_over <= 1'b0;          	// Reset game over state
    	end else begin
        	if (debounced_check_button) begin
            	// On check button press, validate input
            	if (correct) begin
                	// Correct input: proceed to the next sequence
                	new_sequence <= 1'b1;
                	start_display <= 1'b1;
                	game_over <= 1'b0; // Reset game over flag if correct
                	if (speed_factor > 32'd500_000) begin // Prevent too-fast speeds
                    	speed_factor <= speed_factor - 32'd50_000; // Increase speed
                    	new_speed <= 1'b1;
                	end
            	end else if (incorrect_flag) begin
                	// Incorrect input: set game over
                	start_display <= 1'b0;
                	new_sequence <= 1'b0;
                	new_speed <= 1'b0;
                	game_over <= 1'b1; // Signal game over or failure
            	end
        	end else if (start_display) begin
            	// Initiate sequence display
            	new_sequence <= 1'b0;
            	new_speed <= 1'b0;
            	// Implement sequence display logic if needed
        	end else begin
            	// Default state: idle
            	start_display <= 1'b0;
            	new_sequence <= 1'b0;
            	new_speed <= 1'b0;
        	end
    	end
	end

endmodule