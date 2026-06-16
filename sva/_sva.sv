`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// Company: VLSI Design Industry Standard
// Engineer: Principal VLSI Design Engineer
// 
// Module Name: fifo_sva
// Description: SystemVerilog Assertions for formal and dynamic verification.
////////////////////////////////////////////////////////////////////////////////
module fifo_sva #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH = 16,
    parameter int ALMOST_FULL_VAL = 14,
    parameter int ALMOST_EMPTY_VAL = 2
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
    input  logic [$clog2(DEPTH):0] data_count
);

    // 1. Reset Property: Outputs must be in default state during reset
    property p_reset_state;
        @(posedge clk) !rst_n |-> (empty && !full && !almost_full && almost_empty && (data_count == 0));
    endproperty
    a_reset_state: assert property (p_reset_state);

    // 2. FIFO Full No Write: Write pointer/count shouldn't change when full
    property p_full_no_write;
        @(posedge clk) disable iff (!rst_n)
        (full && w_en && !r_en) |=> (full && $stable(data_count));
    endproperty
    a_full_no_write: assert property (p_full_no_write);

    // 3. FIFO Empty No Read: Read pointer/count shouldn't change when empty
    property p_empty_no_read;
        @(posedge clk) disable iff (!rst_n)
        (empty && r_en && !w_en) |=> (empty && $stable(data_count));
    endproperty
    a_empty_no_read: assert property (p_empty_no_read);

    // 4. FIFO Count Increment
    property p_count_increment;
        @(posedge clk) disable iff (!rst_n)
        (w_en && !r_en && !full) |=> (data_count == $past(data_count) + 1'b1);
    endproperty
    a_count_increment: assert property (p_count_increment);

    // 5. FIFO Count Decrement
    property p_count_decrement;
        @(posedge clk) disable iff (!rst_n)
        (r_en && !w_en && !empty) |=> (data_count == $past(data_count) - 1'b1);
    endproperty
    a_count_decrement: assert property (p_count_decrement);

    // 6. FIFO Count Stable on simultaneous read/write
    property p_count_stable;
        @(posedge clk) disable iff (!rst_n)
        (w_en && r_en && !full && !empty) |=> (data_count == $past(data_count));
    endproperty
    a_count_stable: assert property (p_count_stable);

    // 7. Almost Full Flag Assertion
    property p_almost_full;
        @(posedge clk) disable iff (!rst_n)
        (data_count >= ALMOST_FULL_VAL) |-> almost_full;
    endproperty
    a_almost_full: assert property (p_almost_full);

    // 8. Almost Empty Flag Assertion
    property p_almost_empty;
        @(posedge clk) disable iff (!rst_n)
        (data_count <= ALMOST_EMPTY_VAL) |-> almost_empty;
    endproperty
    a_almost_empty: assert property (p_almost_empty);

    // Cover Properties for Key Scenarios
    c_fifo_full: cover property (@(posedge clk) disable iff (!rst_n) full);
    c_fifo_empty: cover property (@(posedge clk) disable iff (!rst_n) empty);
    c_fifo_almost_full: cover property (@(posedge clk) disable iff (!rst_n) almost_full);
    c_fifo_almost_empty: cover property (@(posedge clk) disable iff (!rst_n) almost_empty);
    c_simultaneous_rw: cover property (@(posedge clk) disable iff (!rst_n) (w_en && r_en));

endmodule

// Bind Statement to attach SVA to the top-level design
bind fifo_top fifo_sva #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ALMOST_FULL_VAL(ALMOST_FULL_VAL),
    .ALMOST_EMPTY_VAL(ALMOST_EMPTY_VAL)
) u_fifo_sva (
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
    .data_count(data_count)
);