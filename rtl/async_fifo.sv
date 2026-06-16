`timescale 1ns/1ps
module async_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
) (
    input  logic                  wclk,
    input  logic                  wrst_n,
    input  logic                  winc,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic                  wfull,

    input  logic                  rclk,
    input  logic                  rrst_n,
    input  logic                  rinc,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic                  rempty
);

    // Internal signals
    logic [ADDR_WIDTH-1:0] waddr;
    logic [ADDR_WIDTH-1:0] raddr;
    logic [ADDR_WIDTH:0]   wptr;
    logic [ADDR_WIDTH:0]   rptr;
    logic [ADDR_WIDTH:0]   wq2_rptr;
    logic [ADDR_WIDTH:0]   rq2_wptr;

    // Synchronize read pointer to write clock domain
    sync_ptr #(
        .WIDTH(ADDR_WIDTH + 1)
    ) sync_r2w (
        .clk  (wclk),
        .rst_n(wrst_n),
        .d_in (rptr),
        .d_out(wq2_rptr)
    );

    // Synchronize write pointer to read clock domain
    sync_ptr #(
        .WIDTH(ADDR_WIDTH + 1)
    ) sync_w2r (
        .clk  (rclk),
        .rst_n(rrst_n),
        .d_in (wptr),
        .d_out(rq2_wptr)
    );

    // Dual-Port FIFO Memory
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) mem_inst (
        .wclk  (wclk),
        .wclken(winc),
        .wfull (wfull),
        .waddr (waddr),
        .wdata (wdata),
        .rclk  (rclk),
        .rclken(rinc),
        .raddr (raddr),
        .rdata (rdata)
    );

    // Read pointer and empty flag logic
    rptr_empty #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) rptr_empty_inst (
        .rclk    (rclk),
        .rrst_n  (rrst_n),
        .rinc    (rinc),
        .rq2_wptr(rq2_wptr),
        .rempty  (rempty),
        .raddr   (raddr),
        .rptr    (rptr)
    );

    // Write pointer and full flag logic
    wptr_full #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) wptr_full_inst (
        .wclk    (wclk),
        .wrst_n  (wrst_n),
        .winc    (winc),
        .wq2_rptr(wq2_rptr),
        .wfull   (wfull),
        .waddr   (waddr),
        .wptr    (wptr)
    );

endmodule