`timescale 1ns/1ps
module wptr_full #(
    parameter int ADDR_WIDTH = 4
) (
    input  logic                  wclk,
    input  logic                  wrst_n,
    input  logic                  winc,
    input  logic [ADDR_WIDTH:0]   wq2_rptr, // Synchronized read pointer (Gray)
    output logic                  wfull,
    output logic [ADDR_WIDTH-1:0] waddr,
    output logic [ADDR_WIDTH:0]   wptr      // Gray-coded write pointer
);

    logic [ADDR_WIDTH:0] wbin;
    logic [ADDR_WIDTH:0] wbin_next;
    logic [ADDR_WIDTH:0] wptr_next;

    // Memory write address is the lower bits of the binary pointer
    assign waddr = wbin[ADDR_WIDTH-1:0];

    // Calculate next binary and Gray-coded pointers
    assign wbin_next = wbin + (winc & ~wfull);
    assign wptr_next = wbin_next ^ (wbin_next >> 1);

    // Register pointers
    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin <= '0;
            wptr <= '0;
        end else begin
            wbin <= wbin_next;
            wptr <= wptr_next;
        end
    end

    // Generate full condition
    // Full when MSB and MSB-1 are inverted, and all other bits match
    logic wfull_val;
    assign wfull_val = (wptr_next == {~wq2_rptr[ADDR_WIDTH:ADDR_WIDTH-1], wq2_rptr[ADDR_WIDTH-2:0]});

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wfull <= 1'b0;
        end else begin
            wfull <= wfull_val;
        end
    end

endmodule