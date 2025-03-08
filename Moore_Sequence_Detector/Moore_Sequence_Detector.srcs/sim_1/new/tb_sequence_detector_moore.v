`timescale 1ns / 1ps

module tb_sequence_detector;

// Testbench Signals
reg clock;
reg reset;
reg sequence_in;
wire detector_out;

// Instantiate the Sequence Detector
sequence_detector uut (
    .clock(clock),
    .reset(reset),
    .sequence_in(sequence_in),
    .detector_out(detector_out)
);

// Generate Clock (10 ns period -> 100 MHz)
always #5 clock = ~clock;

initial begin
    // Initialize signals
    clock = 0;
    reset = 1;
    sequence_in = 0;

    // Apply reset for some time
    #20 reset = 0;

    // Apply input sequence: 1011
    #10 sequence_in = 1;
    #10 sequence_in = 0;
    #10 sequence_in = 1;
    #10 sequence_in = 1;  // "1011" detected, detector_out should go HIGH

    // Add extra cases
    #10 sequence_in = 0;
    #10 sequence_in = 1;
    #10 sequence_in = 0;
    #10 sequence_in = 1;
    #10 sequence_in = 1;  // Another "1011" detected

    // Stop simulation
    #50;
    $stop;
end

endmodule
