`timescale 1ns/1ps
module fifo_top #(
    parameter int DATA_WIDTH       = 8,
    parameter int DEPTH            = 16,
    parameter int ALMOST_FULL_VAL  = 14,
    parameter int ALMOST_EMPTY_VAL = 2,
    // Local parameter to automatically calculate address width
    parameter int ADDR_WIDTH       = $clog2(DEPTH)
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    wr_en,
    input  logic [DATA_WIDTH-1:0]   wr_data,
    input  logic                    rd_en,
    output logic [DATA_WIDTH-1:0]   rd_data,
    output logic                    full,
    output logic                    empty,
    output logic                    almost_full,
    output logic                    almost_empty,
    output logic [ADDR_WIDTH:0]     word_count
);

    // Parameter validation to enforce power-of-2 depth
    // synthesis translate_off
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0 || DEPTH == 0) begin
            $display("FATAL ERROR: [fifo_top] DEPTH (%0d) must be a power of 2!", DEPTH);
            $finish;
        end
    end
    // synthesis translate_on

    // Internal signals
    logic [ADDR_WIDTH-1:0] wr_addr;
    logic [ADDR_WIDTH-1:0] rd_addr;
    logic                  wr_en_gated;

    // Gate the write enable to memory to prevent corruption when full
    assign wr_en_gated = wr_en && !full;

    // Instantiate FIFO Control Logic
    fifo_ctrl #(
        .DEPTH(DEPTH),
        .ALMOST_FULL_VAL(ALMOST_FULL_VAL),
        .ALMOST_EMPTY_VAL(ALMOST_EMPTY_VAL),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifo_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_addr(wr_addr),
        .rd_addr(rd_addr),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .word_count(word_count)
    );

    // Instantiate FIFO Memory
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifo_mem (
        .clk(clk),
        .wr_en(wr_en_gated),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

endmodule