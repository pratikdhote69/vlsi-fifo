`timescale 1ns/1ps
/**
 * Module: sync_fifo_sva
 * Description: SystemVerilog Assertions for the Synchronous FIFO.
 */
module sync_fifo_sva #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16,
    parameter int ALMOST_FULL_VAL  = 12,
    parameter int ALMOST_EMPTY_VAL = 4
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  w_en,
    input  logic [DATA_WIDTH-1:0] w_data,
    input  logic                  r_en,
    input  logic [DATA_WIDTH-1:0] r_data,
    input  logic                  full,
    input  logic                  empty,
    input  logic                  almost_full,
    input  logic                  almost_empty,
    input  logic [$clog2(DEPTH):0] data_count,
    input  logic [$clog2(DEPTH):0] w_ptr_bin,
    input  logic [$clog2(DEPTH):0] r_ptr_bin
);

    // 1. Reset Property: Outputs must be in default state during/immediately after reset
    property p_reset_state;
        @(posedge clk) !rst_n |-> (empty == 1'b1 && full == 1'b0 && data_count == '0 && almost_empty == 1'b1 && almost_full == 1'b0);
    endproperty
    a_reset_state: assert property (p_reset_state);

    // 2. Full Flag Property: Full must be asserted when data_count equals DEPTH
    property p_full_flag;
        @(posedge clk) disable iff (!rst_n)
        (data_count == DEPTH) |-> full;
    endproperty
    a_full_flag: assert property (p_full_flag);

    // 3. Empty Flag Property: Empty must be asserted when data_count is 0
    property p_empty_flag;
        @(posedge clk) disable iff (!rst_n)
        (data_count == 0) |-> empty;
    endproperty
    a_empty_flag: assert property (p_empty_flag);

    // 4. Overflow Prevention: Write pointer must not change when writing to a full FIFO
    property p_no_overflow;
        @(posedge clk) disable iff (!rst_n)
        (full && w_en) |=> ($stable(w_ptr_bin));
    endproperty
    a_no_overflow: assert property (p_no_overflow);

    // 5. Underflow Prevention: Read pointer must not change when reading from an empty FIFO
    property p_no_underflow;
        @(posedge clk) disable iff (!rst_n)
        (empty && r_en) |=> ($stable(r_ptr_bin));
    endproperty
    a_no_underflow: assert property (p_no_underflow);

    // 6. Almost Full Flag Property: Asserted when data_count >= ALMOST_FULL_VAL
    property p_almost_full;
        @(posedge clk) disable iff (!rst_n)
        (data_count >= ALMOST_FULL_VAL) |-> almost_full;
    endproperty
    a_almost_full: assert property (p_almost_full);

    // 7. Almost Empty Flag Property: Asserted when data_count <= ALMOST_EMPTY_VAL
    property p_almost_empty;
        @(posedge clk) disable iff (!rst_n)
        (data_count <= ALMOST_EMPTY_VAL) |-> almost_empty;
    endproperty
    a_almost_empty: assert property (p_almost_empty);

    // Cover Properties for Key Scenarios
    c_fifo_full: cover property (@(posedge clk) disable iff (!rst_n) full);
    c_fifo_empty: cover property (@(posedge clk) disable iff (!rst_n) empty);
    c_simultaneous_rw: cover property (@(posedge clk) disable iff (!rst_n) (w_en && r_en && !full && !empty));

endmodule

// Bind statement to attach SVA to the RTL module
bind sync_fifo sync_fifo_sva #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ALMOST_FULL_VAL(ALMOST_FULL_VAL),
    .ALMOST_EMPTY_VAL(ALMOST_EMPTY_VAL)
) u_sync_fifo_sva (
    .clk(clk),
    .rst_n(rst_n),
    .w_en(w_en),
    .w_data(w_data),
    .r_en(r_en),
    .r_data(r_data),
    .full(full),
    .empty(empty),
    .almost_full(almost_full),
    .almost_empty(almost_empty),
    .data_count(data_count),
    .w_ptr_bin(w_ptr_bin),
    .r_ptr_bin(r_ptr_bin)
);