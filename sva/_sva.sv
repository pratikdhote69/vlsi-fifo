`timescale 1ns/1ps
module fifo_sva #(
    parameter int DATA_WIDTH       = 8,
    parameter int DEPTH            = 16,
    parameter int ALMOST_FULL_VAL  = 14,
    parameter int ALMOST_EMPTY_VAL = 2,
    parameter int ADDR_WIDTH       = 4
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    wr_en,
    input  logic [DATA_WIDTH-1:0]   wr_data,
    input  logic                    rd_en,
    input  logic [DATA_WIDTH-1:0]   rd_data,
    input  logic                    full,
    input  logic                    empty,
    input  logic                    almost_full,
    input  logic                    almost_empty,
    input  logic [ADDR_WIDTH:0]     word_count
);

    // 1. Reset State Property
    property p_reset_state;
        @(posedge clk) !rst_n |-> (word_count == 0 && empty == 1 && full == 0 && almost_empty == 1 && almost_full == 0);
    endproperty
    assert_reset_state: assert property (p_reset_state) else $error("SVA Error: Reset state mismatch!");

    // 2. Full Flag Property
    property p_full_flag;
        @(posedge clk) disable iff (!rst_n) (word_count == DEPTH) |-> full;
    endproperty
    assert_full_flag: assert property (p_full_flag) else $error("SVA Error: Full flag not set when word_count == DEPTH");

    // 3. Empty Flag Property
    property p_empty_flag;
        @(posedge clk) disable iff (!rst_n) (word_count == 0) |-> empty;
    endproperty
    assert_empty_flag: assert property (p_empty_flag) else $error("SVA Error: Empty flag not set when word_count == 0");

    // 4. Almost Full Flag Property
    property p_almost_full_flag;
        @(posedge clk) disable iff (!rst_n) (word_count >= ALMOST_FULL_VAL) |-> almost_full;
    endproperty
    assert_almost_full_flag: assert property (p_almost_full_flag) else $error("SVA Error: Almost full flag mismatch");

    // 5. Almost Empty Flag Property
    property p_almost_empty_flag;
        @(posedge clk) disable iff (!rst_n) (word_count <= ALMOST_EMPTY_VAL) |-> almost_empty;
    endproperty
    assert_almost_empty_flag: assert property (p_almost_empty_flag) else $error("SVA Error: Almost empty flag mismatch");

    // 6. Overflow Protection (No write pointer increment on full)
    property p_no_write_on_full;
        @(posedge clk) disable iff (!rst_n) (full && wr_en && !rd_en) |=> ($stable(word_count));
    endproperty
    assert_no_write_on_full: assert property (p_no_write_on_full) else $error("SVA Error: Word count changed on write to full FIFO");

    // 7. Underflow Protection (No read pointer increment on empty)
    property p_no_read_on_empty;
        @(posedge clk) disable iff (!rst_n) (empty && rd_en && !wr_en) |=> ($stable(word_count));
    endproperty
    assert_no_read_on_empty: assert property (p_no_read_on_empty) else $error("SVA Error: Word count changed on read from empty FIFO");

    // Cover Properties for Key Scenarios
    cover_fifo_full: cover property (@(posedge clk) disable iff (!rst_n) full);
    cover_fifo_empty: cover property (@(posedge clk) disable iff (!rst_n) empty);
    cover_fifo_almost_full: cover property (@(posedge clk) disable iff (!rst_n) almost_full);
    cover_fifo_almost_empty: cover property (@(posedge clk) disable iff (!rst_n) almost_empty);
    cover_simultaneous_rw: cover property (@(posedge clk) disable iff (!rst_n) (wr_en && rd_en && !full && !empty));

endmodule

// Bind statement to attach SVA to the top-level module
bind fifo_top fifo_sva #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),
    .ALMOST_FULL_VAL(ALMOST_FULL_VAL),
    .ALMOST_EMPTY_VAL(ALMOST_EMPTY_VAL),
    .ADDR_WIDTH(ADDR_WIDTH)
) u_fifo_sva_bind (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .wr_data(wr_data),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .full(full),
    .empty(empty),
    .almost_full(almost_full),
    .almost_empty(almost_empty),
    .word_count(word_count)
);