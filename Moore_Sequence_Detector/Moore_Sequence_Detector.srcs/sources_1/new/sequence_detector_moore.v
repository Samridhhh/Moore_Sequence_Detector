`timescale 1ns / 1ps

module sequence_detector (
    input wire clock,        // Clock signal
    input wire reset,        // Active-high Reset
    input wire sequence_in,  // Serial binary input
    output reg detector_out  // Output: 1 if "1011" detected, else 0
);

// State encoding using parameters
parameter Zero       = 3'b000; // Initial State
parameter One        = 3'b001; // "1" detected
parameter OneZero    = 3'b011; // "10" detected
parameter OneZeroOne = 3'b010; // "101" detected
parameter Detected   = 3'b110; // "1011" detected

// State variables
reg [2:0] current_state, next_state;

// Sequential logic: State transition
always @(posedge clock or posedge reset) begin
    if (reset) 
        current_state <= Zero;  // Reset to initial state
    else 
        current_state <= next_state; // Move to next state
end

// Combinational logic: Next state logic
always @(*) begin
    case (current_state)
        Zero:        next_state = (sequence_in) ? One : Zero;
        One:         next_state = (sequence_in) ? One : OneZero;
        OneZero:     next_state = (sequence_in) ? OneZeroOne : Zero;
        OneZeroOne:  next_state = (sequence_in) ? Detected : OneZero;
        Detected:    next_state = (sequence_in) ? One : OneZero;
        default:     next_state = Zero;
    endcase
end

// Output logic: Detector output depends only on current state
always @(*) begin
    case (current_state)
        Detected:    detector_out = 1;
        default:     detector_out = 0;
    endcase
end

endmodule
