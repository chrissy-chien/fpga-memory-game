`timescale 1ns / 1ps

// Note: This module was taken from the Keypad demo from the Diligent website:
// https://digilent.com/reference/programmable-logic/nexys-3/start?redirect=1
// And was modified to fit our lab.

module keypad_decoder(
    input clk,                          // 100MHz onboard clock
    input reset,                        // Reset signal
    input [3:0] row,                    // Rows on KYPD
    output reg [3:0] col,               // Columns on KYPD
    output reg [3:0] keypad_decode_out, // Output data
    output reg valid                    // High when valid key is pressed
    );
	
	reg [19:0] debounce_counter;
	reg [1:0] state;
	reg [3:0] current_row;
	reg [3:0] detected_col;
	
	localparam IDLE = 2'b00,
	           SCAN = 2'b01,
	           DEBOUNCE = 2'b10;
	
    // Key mapping function for rows and columns
    function [3:0] get_key;
        input [3:0] row_val;
        input [3:0] col_val;
        begin
            case (row_val)
            
                4'b1110: begin // R1 active low
                    case (col_val)
                        4'b1110: get_key = 4'd1; // 1
                        4'b1101: get_key = 4'd2; // 2
                        4'b1011: get_key = 4'd3; // 3
                        4'b0111: get_key = 4'd10; // A (unused)
                        default: get_key = 4'd15;
                    endcase
                end
                
                4'b1101: begin // R2
                    case (col_val)
                        4'b1110: get_key = 4'd4; // 4
                        4'b1101: get_key = 4'd5; // 5
                        4'b1011: get_key = 4'd6; // 6
                        4'b0111: get_key = 4'd11; // B (unused)
                        default: get_key = 4'd15;
                    endcase
                end
                
                4'b1011: begin // R3
                    case (col_val)
                        4'b1110: get_key = 4'd7; // 7
                        4'b1101: get_key = 4'd8; // 8
                        4'b1011: get_key = 4'd9; // 9
                        4'b0111: get_key = 4'd12; // C (unused)
                        default: get_key = 4'd15;
                    endcase 
                end
                
                4'b0111: begin // R4
                    case (col_val)
                        4'b1110: get_key = 4'd0; // 0
                        4'b1101: get_key = 4'd15; // F (unused)
                        4'b1011: get_key = 4'd15; // E (unused)
                        4'b0111: get_key = 4'd15; // D (unused)
                        default: get_key = 4'd15;
                    endcase 
                end
                default: get_key = 4'd15;
            endcase
        end
    endfunction

	always @(posedge clk or posedge reset) begin
	   if (reset) begin
	       state <= IDLE;
	       col <= 4'b1111;
	       keypad_decode_out <= 4'b0000;
	       valid <= 1'b0;
	       debounce_counter <= 20'b0;
	   end else begin
	       case (state)
	       
	           IDLE: begin
	               col <= 4'b1110; // Start to scan first column
	               current_row <= 4'b0000;
	               state <= SCAN;
	               valid <= 1'b0;
	           end
	           
	           SCAN: begin
	               // Cycle through columns
	               if (col == 4'b0111)
	                   col <= 4'b1110;
	               else
	                   col <= {col[2:0], col[3]};
	                   
	               if (row != 4'b1111) begin
	                   detected_col <= col;
	                   state <= DEBOUNCE;
	               end
	           end
	           
	           DEBOUNCE: begin
	               // Debouncer for keypad buttons
	               if (debounce_counter <= 20'd1_000_000) begin
	                   debounce_counter <= debounce_counter + 1;
	               end else begin
	                   debounce_counter <= 20'b0;
	                   current_row <= row;
	                   
	                   // Map row and column to key output
	                   keypad_decode_out <= get_key(~row, ~col);
	                   valid <= 1'b1;
	                   state <= IDLE;
	               end
	           end
	           
	       endcase
	   end
	end

endmodule
