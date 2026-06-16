`timescale 1ns/1ps
module fifo_mem #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
) (
    input  logic                  wclk,
    input  logic                  wclken,
    input  logic                  wfull,
    input  logic [ADDR_WIDTH-1:0] waddr,
    input  logic [DATA_WIDTH-1:0] wdata,
    input  logic                  rclk,
    input  logic                  rclken,
    input  logic [ADDR_WIDTH-1:0] raddr,
    output logic [DATA_WIDTH-1:0] rdata
);

    localparam int DEPTH = 1 << ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] mem [DEPTH-1:0];

    // Synchronous write operation
    always_ff @(posedge wclk) begin
        if (wclken && !wfull) begin
            mem[waddr] <= wdata;
        end
    end

    // Asynchronous read operation
    assign rdata = mem[raddr];

endmodule