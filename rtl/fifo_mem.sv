`timescale 1ns/1ps
module fifo_mem #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16,
    parameter int ADDR_WIDTH = 4
)(
    input  logic                    clk,
    input  logic                    wr_en,
    input  logic [ADDR_WIDTH-1:0]   wr_addr,
    input  logic [DATA_WIDTH-1:0]   wr_data,
    input  logic [ADDR_WIDTH-1:0]   rd_addr,
    output logic [DATA_WIDTH-1:0]   rd_data
);

    // Memory array declaration
    logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];

    // Synchronous write port
    always_ff @(posedge clk) begin
        if (wr_en) begin
            mem[wr_addr] <= wr_data;
        end
    end

    // Asynchronous read port to support First-Word Fall-Through (FWFT)
    assign rd_data = mem[rd_addr];

endmodule