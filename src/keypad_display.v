`timescale 1ns / 1ps

module keypad_display(
	input clk,
	input reset,
	input valid_input,    	// High when a valid keypad input is detected
	input [3:0] keypad_value, // Keypad value from the keypad_decoder (0-9)
	output reg [3:0] digit3,  // Display digit for position 3
	output reg [3:0] digit4   // Display digit for position 4
);

	reg [3:0] input_buffer [1:0]; // Buffer to hold two keypad inputs

	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	input_buffer[0] <= 4'b0000; // Clear buffer
        	input_buffer[1] <= 4'b0000;
        	digit3 <= 4'b0000;
        	digit4 <= 4'b0000;
    	end else if (valid_input) begin
        	// Shift digits in buffer
        	input_buffer[1] <= input_buffer[0];
        	input_buffer[0] <= keypad_value;

        	// Update display digits
        	digit3 <= input_buffer[1];
        	digit4 <= input_buffer[0];
    	end
	end
endmodule