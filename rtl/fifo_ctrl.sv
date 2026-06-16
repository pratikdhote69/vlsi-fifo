`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// Company: VLSI Design Industry Standard
// Engineer: Principal VLSI Design Engineer
// 
// Module Name: fifo_ctrl
// Description: Pointer generation, wrap-around tracking, and status flag logic.
////////////////////////////////////////////////////////////////////////////////
module fifo_ctrl #(
    parameter int DEPTH = 16,
    parameter int ALMOST_FULL_VAL = 14,
    parameter int ALMOST_EMPTY_VAL = 2
)(
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic                     w_en,
    input  logic                     r_en,
    output logic [$clog2(DEPTH)-1:0] w_addr,
    output logic [$clog2(DEPTH)-1:0] r_addr,
    output logic                     mem_w_en,
    output logic                     full,
    output logic                     empty,
    output logic                     almost_full,
    output logic                     almost_empty,
    output logic [$clog2(DEPTH):0]   data_count
);

    localparam int ADDR_WIDTH = $clog2(DEPTH);

    // Pointers with an extra bit for wrap-around detection
    logic [ADDR_WIDTH:0] w_ptr;
    logic [ADDR_WIDTH:0] r_ptr;

    // Write Pointer Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_ptr <= '0;
        end else if (w_en && !full) begin
            w_ptr <= w_ptr + 1'b1;
        end
    end

    // Read Pointer Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_ptr <= '0;
        end else if (r_en && !empty) begin
            r_ptr <= r_ptr + 1'b1;
        end
    end

    // Memory Write Enable (Gated with Full to prevent overflow)
    assign mem_w_en = w_en && !full;

    // Memory Addresses (LSBs of the pointers)
    assign w_addr = w_ptr[ADDR_WIDTH-1:0];
    assign r_addr = r_ptr[ADDR_WIDTH-1:0];

    // Status Flags
    assign empty = (w_ptr == r_ptr);
    assign full  = (w_ptr[ADDR_WIDTH] != r_ptr[ADDR_WIDTH]) && 
                   (w_ptr[ADDR_WIDTH-1:0] == r_ptr[ADDR_WIDTH-1:0]);

    // Data Count Calculation (Two's complement handles wrap-around automatically)
    assign data_count = w_ptr - r_ptr;

    // Threshold Flags
    assign almost_full  = (data_count >= ALMOST_FULL_VAL);
    assign almost_empty = (data_count <= ALMOST_EMPTY_VAL);

endmodule