`timescale 1ns / 1ps

module seven_segment_display (
	input clk,
	input reset,
	input [3:0] score,   	// Single-digit score (position 1)
	input [3:0] digit3,  	// Sequence digit (position 3)
	input [3:0] digit4,  	// Sequence digit (position 4)
	output reg [6:0] segment,
	output reg [3:0] anode
);

	// LUT for seven-segment encoding
	function [6:0] encode;
    	input [3:0] digit;
    	begin
        	case (digit)
            	4'd0:	encode = 7'b1000000;
            	4'd1:	encode = 7'b1111001;
            	4'd2:	encode = 7'b0100100;
            	4'd3:	encode = 7'b0110000;
            	4'd4:	encode = 7'b0011001;
            	4'd5:	encode = 7'b0010010;
            	4'd6:	encode = 7'b0000010;
            	4'd7:	encode = 7'b1111000;
            	4'd8:	encode = 7'b0000000;
            	4'd9:	encode = 7'b0010000;
            	default: encode = 7'b1111111; // All segments off for blank
        	endcase
    	end
	endfunction

	reg [1:0] display_state; // State to cycle through digits (positions 1-4)

	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	display_state <= 2'b00;
    	end else begin
        	display_state <= display_state + 1; // Cycle through digits
    	end
	end

	always @(*) begin
    	case (display_state)
        	2'b00: begin
            	// Display score in position 1
            	anode = 4'b1110; // Activate position 1
            	segment = encode(score);
        	end
        	2'b01: begin
            	// Leave position 2 blank
            	anode = 4'b1101; // Activate position 2
            	segment = 7'b1111111; // Blank
        	end
        	2'b10: begin
            	// Display sequence digit in position 3
            	anode = 4'b1011; // Activate position 3
            	segment = encode(digit3);
        	end
        	2'b11: begin
            	// Display sequence digit in position 4
            	anode = 4'b0111; // Activate position 4
            	segment = encode(digit4);
        	end
        	default: begin
            	// Turn off all displays by default
            	anode = 4'b1111;
            	segment = 7'b1111111;
        	end
    	endcase
	end
endmodule