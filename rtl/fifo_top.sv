`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// Company: VLSI Design Industry Standard
// Engineer: Principal VLSI Design Engineer
// 
// Module Name: fifo_top
// Description: Top-level wrapper for the Synchronous FIFO.
////////////////////////////////////////////////////////////////////////////////
module fifo_top #(
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
    output logic [DATA_WIDTH-1:0] r_data,
    output logic                  full,
    output logic                  empty,
    output logic                  almost_full,
    output logic                  almost_empty,
    output logic [$clog2(DEPTH):0] data_count
);

    localparam int ADDR_WIDTH = $clog2(DEPTH);

    // Elaboration-time parameter validation
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0 || DEPTH == 0) begin
            $error("FATAL: DEPTH parameter must be a power of 2.");
            $finish;
        end
    end

    // Internal Interconnect Signals
    logic [ADDR_WIDTH-1:0] w_addr;
    logic [ADDR_WIDTH-1:0] r_addr;
    logic                  mem_w_en;

    // Instantiate FIFO Controller
    fifo_ctrl #(
        .DEPTH(DEPTH),
        .ALMOST_FULL_VAL(ALMOST_FULL_VAL),
        .ALMOST_EMPTY_VAL(ALMOST_EMPTY_VAL)
    ) u_fifo_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .r_en(r_en),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .mem_w_en(mem_w_en),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .data_count(data_count)
    );

    // Instantiate FIFO Memory
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifo_mem (
        .clk(clk),
        .w_en(mem_w_en),
        .w_addr(w_addr),
        .w_data(w_data),
        .r_en(r_en),
        .r_addr(r_addr),
        .r_data(r_data)
    );

endmodule