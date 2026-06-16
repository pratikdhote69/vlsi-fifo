`timescale 1ns/1ps
module rptr_empty #(
    parameter int ADDR_WIDTH = 4
) (
    input  logic                  rclk,
    input  logic                  rrst_n,
    input  logic                  rinc,
    input  logic [ADDR_WIDTH:0]   rq2_wptr, // Synchronized write pointer (Gray)
    output logic                  rempty,
    output logic [ADDR_WIDTH-1:0] raddr,
    output logic [ADDR_WIDTH:0]   rptr      // Gray-coded read pointer
);

    logic [ADDR_WIDTH:0] rbin;
    logic [ADDR_WIDTH:0] rbin_next;
    logic [ADDR_WIDTH:0] rptr_next;

    // Memory read address is the lower bits of the binary pointer
    assign raddr = rbin[ADDR_WIDTH-1:0];

    // Calculate next binary and Gray-coded pointers
    assign rbin_next = rbin + (rinc & ~rempty);
    assign rptr_next = rbin_next ^ (rbin_next >> 1);

    // Register pointers
    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin <= '0;
            rptr <= '0;
        end else begin
            rbin <= rbin_next;
            rptr <= rptr_next;
        end
    end

    // Generate empty condition
    // Empty when read pointer matches synchronized write pointer
    logic rempty_val;
    assign rempty_val = (rptr_next == rq2_wptr);

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rempty <= 1'b1;
        end else begin
            rempty <= rempty_val;
        end
    end

endmodule