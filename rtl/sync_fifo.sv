`timescale 1ns/1ps
/**
 * Module: sync_fifo
 * Description: Top-level Parameterized Synchronous FIFO.
 *              Instantiates the memory block and implements pointer/status logic.
 */
module sync_fifo #(
    parameter int DATA_WIDTH       = 8,
    parameter int DEPTH            = 16,
    parameter int ALMOST_FULL_VAL  = 12,
    parameter int ALMOST_EMPTY_VAL = 4
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
    
    // Static elaboration check to ensure power-of-2 depth
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0 || DEPTH == 0) begin
            $display("ERROR: [sync_fifo] DEPTH parameter must be a power of 2.");
            $finish;
        end
    end

    // Pointers with an extra bit for wrap-around detection
    logic [ADDR_WIDTH:0] w_ptr_bin;
    logic [ADDR_WIDTH:0] r_ptr_bin;

    // Memory addresses derived from pointers
    wire [ADDR_WIDTH-1:0] w_addr = w_ptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] r_addr = r_ptr_bin[ADDR_WIDTH-1:0];

    // Write pointer control
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_ptr_bin <= '0;
        end else if (w_en && !full) begin
            w_ptr_bin <= w_ptr_bin + 1'b1;
        end
    end

    // Read pointer control
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_ptr_bin <= '0;
        end else if (r_en && !empty) begin
            r_ptr_bin <= r_ptr_bin + 1'b1;
        end
    end

    // Memory Instance
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifo_mem (
        .clk(clk),
        .w_en(w_en && !full),
        .w_addr(w_addr),
        .w_data(w_data),
        .r_addr(r_addr),
        .r_data(r_data)
    );

    // Status Flags Generation
    assign empty = (w_ptr_bin == r_ptr_bin);
    assign full  = (w_ptr_bin[ADDR_WIDTH] != r_ptr_bin[ADDR_WIDTH]) && 
                   (w_ptr_bin[ADDR_WIDTH-1:0] == r_ptr_bin[ADDR_WIDTH-1:0]);

    // Data Count Calculation (Modulo arithmetic handles wrap-around automatically)
    assign data_count = w_ptr_bin - r_ptr_bin;

    // Threshold Flags
    assign almost_full  = (data_count >= ALMOST_FULL_VAL);
    assign almost_empty = (data_count <= ALMOST_EMPTY_VAL);

endmodule