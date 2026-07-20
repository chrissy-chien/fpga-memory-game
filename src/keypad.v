`timescale 1ns / 1ps

module keypad(
	input clk,
	input reset,
	input [3:0] row,       	// Keypad row inputs
	output [3:0] col,      	// Keypad column outputs
	output valid_input,    	// High when a valid key is detected
	output [3:0] keypad_value, // Decoded keypad value
	output [3:0] digit3,   	// Recent input (for display position 3)
	output [3:0] digit4    	// Recent input (for display position 4)
);

	wire [3:0] decoded_value;

	// Keypad Decoder
	keypad_decoder decoder (
    	.clk(clk),
    	.reset(reset),
    	.row(row),
    	.col(col),
    	.keypad_decode_out(decoded_value),
    	.valid(valid_input)
	);

	// Keypad Display
	keypad_display display (
    	.clk(clk),
    	.reset(reset),
    	.valid_input(valid_input),
    	.keypad_value(decoded_value),
    	.digit3(digit3),
    	.digit4(digit4)
	);

	assign keypad_value = decoded_value; // Forward decoded value for external use

endmodule



