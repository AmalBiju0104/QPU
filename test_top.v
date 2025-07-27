`timescale 1ns / 1ps

module test_top;
    reg clk;
    reg reset;

    // Instantiate your top module
    top DUT (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        #10;
        reset = 0;

        // Let it run through all instructions (3 steps)
        #100;

        $display("Simulation complete.");
        $finish;
    end
endmodule
