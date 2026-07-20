`timescale 1ns / 1ps

module clock_divider(
    input clk,                  // Onboard 100MHz clock
    input reset,
    input [31:0] speed_factor,
    output reg slow_clk
);

reg [31:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        slow_clk <= 0;
    end else begin
        if (counter == (50_000_000 - speed_factor)) begin
            counter <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
