`timescale 1ns/1ps

module async_fifo_sva #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
) (
    input  logic                  wclk,
    input  logic                  wrst_n,
    input  logic                  winc,
    input  logic [DATA_WIDTH-1:0] wdata,
    input  logic                  wfull,
    input  logic                  rclk,
    input  logic                  rrst_n,
    input  logic                  rinc,
    input  logic [DATA_WIDTH-1:0] rdata,
    input  logic                  rempty,
    input  logic [ADDR_WIDTH:0]   wptr,
    input  logic [ADDR_WIDTH:0]   rptr
);

    // 1. Reset Property: Write domain initialization
    property p_write_reset;
        @(posedge wclk) !wrst_n |-> (wptr == '0 && wfull == 1'b0);
    endproperty
    a_write_reset: assert property (p_write_reset);

    // 2. Reset Property: Read domain initialization
    property p_read_reset;
        @(posedge rclk) !rrst_n |-> (rptr == '0 && rempty == 1'b1);
    endproperty
    a_read_reset: assert property (p_read_reset);

    // 3. Write pointer Gray code property: only 1 bit changes at a time
    property p_wptr_gray;
        @(posedge wclk) disable iff (!wrst_n)
        (wptr != $past(wptr)) |-> ($countones(wptr ^ $past(wptr)) == 1);
    endproperty
    a_wptr_gray: assert property (p_wptr_gray);

    // 4. Read pointer Gray code property: only 1 bit changes at a time
    property p_rptr_gray;
        @(posedge rclk) disable iff (!rrst_n)
        (rptr != $past(rptr)) |-> ($countones(rptr ^ $past(rptr)) == 1);
    endproperty
    a_rptr_gray: assert property (p_rptr_gray);

    // 5. No write pointer increment when full and write is attempted
    property p_no_wptr_inc_on_full;
        @(posedge wclk) disable iff (!wrst_n)
        (wfull && winc) |-> ($stable(wptr));
    endproperty
    a_no_wptr_inc_on_full: assert property (p_no_wptr_inc_on_full);

    // 6. No read pointer increment when empty and read is attempted
    property p_no_rptr_inc_on_empty;
        @(posedge rclk) disable iff (!rrst_n)
        (rempty && rinc) |-> ($stable(rptr));
    endproperty
    a_no_rptr_inc_on_empty: assert property (p_no_rptr_inc_on_empty);

    // Coverages
    c_fifo_full: cover property (@(posedge wclk) disable iff (!wrst_n) wfull);
    c_fifo_empty: cover property (@(posedge rclk) disable iff (!rrst_n) rempty);
    c_simultaneous_wr_rd: cover property (
        @(posedge wclk) disable iff (!wrst_n) (winc && !wfull) ##0
        @(posedge rclk) disable iff (!rrst_n) (rinc && !rempty)
    );

endmodule

// Bind statement to attach SVA to the top-level RTL
bind async_fifo async_fifo_sva #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) i_async_fifo_sva (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .winc(winc),
    .wdata(wdata),
    .wfull(wfull),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rinc(rinc),
    .rdata(rdata),
    .rempty(rempty),
    .wptr(wptr),
    .rptr(rptr)
);