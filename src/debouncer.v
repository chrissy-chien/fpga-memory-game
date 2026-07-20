`timescale 1ns / 1ps

module debouncer(
	input clk,              	// Onboard 100MHz clock
	input reset,            	// Reset signal
	input button_input,     	// Raw button input
	output reg debounced_output // Stable, debounced output
);
	reg [19:0] counter;     	// 20-bit counter for ~10ms debounce
	reg sync_0, sync_1;     	// Synchronization registers

	// Synchronize the button input to avoid metastability
	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	sync_0 <= 1'b0;
        	sync_1 <= 1'b0;
    	end else begin
        	sync_0 <= button_input;
        	sync_1 <= sync_0;
    	end
	end

	// Debounce Logic
	always @(posedge clk or posedge reset) begin
    	if (reset) begin
        	counter <= 20'd0;
        	debounced_output <= 1'b0;
    	end else if (sync_1 == debounced_output) begin
        	// If the current input matches the debounced output, reset the counter
        	counter <= 20'd0;
    	end else begin
        	// If there's a mismatch, increment the counter
        	counter <= counter + 1;
        	if (counter == 20'd1_000_000) begin // ~10ms at 100MHz
            	debounced_output <= sync_1; // Update debounced output to match the stable input
            	counter <= 20'd0;       	// Reset counter
        	end
    	end
	end
endmodule
